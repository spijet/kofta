class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :redis
  def redis
    @redis_stats = {}
    redis = Redis.new(
      host: REDIS_CONFIG['host'],
      port: REDIS_CONFIG['port'],
      db:   REDIS_CONFIG['worker_db']
    )
    reping = redis.ping
  rescue Exception => e
      @redis_stats[:alive] = false
      @redis_stats[:message] = e.message
  else
    if reping == "PONG"
      @redis_stats[:alive] = true
      @redis_stats[:info] = redis.info
    end
  end

end
