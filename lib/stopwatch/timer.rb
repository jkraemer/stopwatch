require 'json'

module Stopwatch
  class Timer
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
      if hours = runtime_hours and
          time_entry = TimeEntry.find_by_id(data[:time_entry_id])

        time_entry.update_column :hours, time_entry.hours + hours
      end
      data[:started_at] = nil
      save
    end

    def save
      user.pref[:current_timer] = data.to_json
      user.pref.save
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
