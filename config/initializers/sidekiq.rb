require 'sidekiq'

REDIS_CONFIG = YAML.load_file(Rails.root.join('config', 'redis.yml'))[Rails.env]
redis_url = "redis://#{REDIS_CONFIG['host']}:#{REDIS_CONFIG['port']}/#{REDIS_CONFIG['sidekiq_db']}"

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
  config.server_middleware do |chain|
    chain.add Sidekiq::Middleware::Server::RetryJobs, :max_retries => 0
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end
