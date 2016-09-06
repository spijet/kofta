class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action do
    # Only output verbose info if it's Redis/Sidekiq stats page.
    verbose = action_name == 'sidekiq' ? true : false
    redis(verbose)
  end
  def redis(verbose)
    @redis_stats = {}
    redis = Redis.new(
      host: REDIS_CONFIG['host'],
      port: REDIS_CONFIG['port'],
      db:   REDIS_CONFIG['worker_db']
    )
    redis_ping = redis.ping
  rescue Exception => e
      @redis_stats[:alive] = false
      @redis_stats[:message] = e.message if verbose
  else
    if redis_ping == 'PONG'
      @redis_stats[:alive] = true
      @redis_info = redis.info if verbose
    end
  end

end
