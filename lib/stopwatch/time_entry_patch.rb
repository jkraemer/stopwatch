module Stopwatch
  module TimeEntryPatch
    def self.apply
      TimeEntry.prepend self unless TimeEntry < self
    end

    def self.prepended(base)
      base.class_eval do
        before_destroy :stop_timer
      end
    end

    def stop_timer
      t = Stopwatch::Timer.new(user)
      t.update(stop: true) if t.running?
    end
  end
end
