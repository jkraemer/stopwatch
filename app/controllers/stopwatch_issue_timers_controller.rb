class StopwatchIssueTimersController < StopwatchController
  before_action :find_issue
  before_action :authorize_log_time

  def start
    t = Stopwatch::IssueTimer.new(issue: @issue)
    if t.running?
      head 422; return
    end

    time_entry = User.current.todays_time_entry_for(@issue)
    if time_entry.new_record?
      sys_default_activity = time_entry.activity
      time_entry.activity = Stopwatch.default_activity_for time_entry
    end

    r = Stopwatch::StartTimer.new(time_entry).call
    if r.success?
      @started_time_entry = time_entry
      render status: :created
    else
      @time_entry = time_entry
      # in case the setting is 'always ask', still preset the form to the global default
      @time_entry.activity ||= sys_default_activity
      @time_entry.errors.clear
      render status: :ok
    end
  end

  def stop
    r = Stopwatch::StopTimer.new.call
    unless r.success?
      logger.error "unable to stop timer"
      head 422; return
    end
  end

  private

  def authorize_log_time
    User.current.allowed_to?(:log_time, @project) or deny_access
  end

  def find_issue
    @issue = Issue.find params[:issue_id]
    @project = @issue.project
  end
end
