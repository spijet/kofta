class StatsController < ApplicationController
  def gc
    @stats = GC.stat
  end

  def rufus
    @jobs = KOFTA::Schedule.jobs
  end

  def sidekiq
    return false unless @redis_stats[:alive]
    @sk_stats = Sidekiq::Stats.new || {}
    @sk_procs = Sidekiq::ProcessSet.new || {}
    @sk_busy  = 0
    @sk_threads = 0
    @sk_procs.each do |process|
      @sk_busy    += process['busy'].to_i
      @sk_threads += process['concurrency'].to_i
    end
  end

  def index; end
end
