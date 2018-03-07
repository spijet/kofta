# frozen_string_literal: true

module KOFTA
  class Redis
    @redis = ::Redis.new(
      host: REDIS_CONFIG['host'],
      port: REDIS_CONFIG['port'],
      db:   REDIS_CONFIG['worker_db']
    )

    def self.status(verbose = false)
      redis_stats = { alive: false }
      redis_ping = @redis.ping
    rescue StandardError => e
      redis_stats[:message] = e.message if verbose
      return redis_stats
    else
      if redis_ping == 'PONG'
        redis_stats[:alive] = true
        redis_stats[:info] = @redis.info if verbose
      end
      return redis_stats
    end
  end
end
