module Stopwatch
  module TimeEntryPatch
    extend ActiveSupport::Concern

    prepended do
      before_destroy :stop_timer
    end

    def stop_timer
      t = Stopwatch::Timer.new(user)
      t.update(stop: true) if t.running?
    end
  end
end
