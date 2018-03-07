class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action do
    @redis_stats = KOFTA::Redis.status(action_name == 'sidekiq')
  end
end
