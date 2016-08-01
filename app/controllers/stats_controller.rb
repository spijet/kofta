class StatsController < ApplicationController
  def gc
  end

  def rufus
  end

  def sidekiq
    @sk_stats = Sidekiq::Stats.new
  end

  def index
  end
end
