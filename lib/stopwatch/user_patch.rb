module Stopwatch
  module UserPatch
    def self.apply
      User.prepend self unless User < self
    end

    def timer_running?
      Stopwatch::Timer.new(self).running?
    end

    def is_running_timer?(time_entry)
      id = running_time_entry_id
      id.present? and time_entry.id == id
    end

    def running_time_entry_id
      timer = Stopwatch::Timer.new(self)
      timer.time_entry_id if timer.running?
    end
  end
end
