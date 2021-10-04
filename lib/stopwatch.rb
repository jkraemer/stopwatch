# frozen_string_literal: true

module Stopwatch
  def self.settings
    Setting.plugin_stopwatch
  end

  def self.default_activity
    if id = settings['default_activity'].presence
      if id.to_s =~ /^\d+$/
        TimeEntryActivity.find_by_id id
      else
        id
      end
    end
  end

  def self.default_activity_for(time_entry)
    default = Stopwatch.default_activity
    return nil if default == 'always_ask'

    project = time_entry.project || time_entry.issue&.project

    if project.nil?
      activities = TimeEntryActivity.shared.active
    else
      activities = project.activities
    end

    if default == 'system'
      activities.detect(&:is_default?) || activities.detect{|a| a.parent&.is_default?} || (activities.one? && activities[0]).presence
    else
      return activities.detect{ |a| a == default || a.parent == default }
    end
  end
end
