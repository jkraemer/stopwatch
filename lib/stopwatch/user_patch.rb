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

    def todays_time_entry_for(issue)
      TimeEntry.order(created_on: :desc).
        find_or_initialize_by(user: self, issue: issue, spent_on: today)
    end
  end
end

unless User.included_modules.include?(Stopwatch::UserPatch)
  User.send(:include, Stopwatch::UserPatch)
end
