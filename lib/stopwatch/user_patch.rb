module Stopwatch
  module UserPatch
    def self.apply
      User.prepend self unless User < self
    end

    def timer_running?
      Stopwatch::Timer.new(self).running?
    end

    def is_running_timer?(time_entry)
      timer = Stopwatch::Timer.new(self)
      timer.running? and timer.time_entry_id == time_entry.id
    end
  end
end
