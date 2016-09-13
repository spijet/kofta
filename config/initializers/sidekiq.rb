require 'sidekiq'

REDIS_CONFIG = YAML.load_file(Rails.root.join('config', 'redis.yml'))[Rails.env]
redis_url = "redis://#{REDIS_CONFIG['host']}:#{REDIS_CONFIG['port']}/#{REDIS_CONFIG['sidekiq_db']}"

module Sidekiq
  module Middleware
    module Server
      # This class lets us do GC every N jobs in worker process instead of doing
      # it on every job.
      class Profiler
        # Number of jobs to process before reporting
        JOBS = 100

        class << self
          mattr_accessor :counter
          self.counter = 0

          def synchronize(&block)
            @lock ||= Mutex.new
            @lock.synchronize(&block)
          end
        end

        def call(worker_instance, item, queue)
          begin
            yield
          ensure
            self.class.synchronize do
              self.class.counter += 1

              if self.class.counter % JOBS == 0
                Sidekiq.logger.info "#{Time.now}: #{JOBS} jobs passed, time to GC."
                GC.start
              end
            end
          end
        end
      end
    end
  end
end

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
  config.server_middleware do |chain|
    chain.add Sidekiq::Middleware::Server::RetryJobs, :max_retries => 0
    chain.add Sidekiq::Middleware::Server::Profiler
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end
