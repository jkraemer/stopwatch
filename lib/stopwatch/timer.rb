require 'json'

module Stopwatch
  class Timer

    class HourFormatter
      include ApplicationHelper

      def initialize(s)
        @s = s
      end

      def html_hours
        super format_hours
      end

      def format_hours
        super @s
      end
    end


    attr_reader :user

    def initialize(user)
      @user = user
    end

    def running?
      data[:started_at].present?
    end

    def start(time_entry = nil)
      fail "timer is already running" if running?
      data[:started_at] = Time.now.to_i
      data[:time_entry_id] = time_entry.id if time_entry
      save
    end

    def stop
      update stop: true
    end

    # saves currently logged time to the time entry and resets the started_at
    # timestamp to either nil (stop: true) or current time.
    def update(stop: false)
      if hours = runtime_hours and entry = self.time_entry
        time_entry.update_column :hours, entry.read_attribute(:hours) + hours
      end
      data[:started_at] = stop || !running? ? nil : Time.now.to_i
      save
    end

    def time_spent
      h = runtime_hours || 0
      if e = time_entry
        h += e.hours
      end
      h
    end

    def to_json
      formatter = HourFormatter.new(time_spent)
      {
        time_entry_id: time_entry_id,
        time_spent: formatter.format_hours,
        html_time_spent: formatter.html_hours,
        running: running?,
        issue_id: time_entry&.issue_id
      }.to_json
    end

    def save
      user.pref[:current_timer] = data.to_json
      user.pref.save
    end

    def time_entry_id
      data[:time_entry_id]
    end

    def time_entry
      TimeEntry.find_by_id(time_entry_id)
    end

    private

    def data
      @data ||= (t = user.pref[:current_timer]) ? JSON.parse(t).symbolize_keys : {}
    end

    def runtime_hours
      if start = data[:started_at]
        runtime = Time.now.to_i - start
        return runtime.to_f / 1.hour
      end
    end

  end
end
