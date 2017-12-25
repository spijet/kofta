# frozen_string_literal: true

require 'sidekiq'

REDIS_CONFIG = YAML.load(ERB.new(File.read(Rails.root.join('config', 'redis.yml'))).result)[Rails.env]
redis_url = format 'redis://%<host>s:%<port>d/%<sidekiq_db>s',
                   REDIS_CONFIG.symbolize_keys

module Sidekiq
  module Middleware
    module Server
      # This class lets us do GC every N jobs in worker process instead of doing
      # it on every job.
      class Profiler
        # Number of jobs to process before doing a GC
        JOBS = 100

        class << self
          mattr_accessor :counter
          self.counter = 0

          def synchronize(&block)
            @lock ||= Mutex.new
            @lock.synchronize(&block)
          end
        end

        def call(_worker_instance, _item, _queue)
          begin
            yield
          ensure
            self.class.synchronize do
              self.class.counter += 1
              if (self.class.counter % JOBS).zero?
                GC.start
                self.class.counter = 0
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
    chain.add Sidekiq::Middleware::Server::RetryJobs, max_retries: 0
    chain.add Sidekiq::Middleware::Server::Profiler
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end
