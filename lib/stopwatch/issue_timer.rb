module Stopwatch
  class IssueTimer

    def initialize(issue:, user: User.current)
      @issue = issue
      @user = user
    end

    def running?
      running_time_entry.present?
    end

    def running_time_entry
      @running_time_entry ||= @issue.time_entries.find_by_id(@user.running_time_entry_id)
    end

  end
end
