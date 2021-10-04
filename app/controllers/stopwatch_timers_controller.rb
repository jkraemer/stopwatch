# weiter
#
# - update title / menu item after starting new entry
# - update time entry row after context menu stop (reflect saved time)
# - 0:60 anstelle 1:00? Redmine-bug?
#
# - remember last activity, preselect that in 'new' form
# - same for project, unless we are in a project context
# - focus first field that needs an action, depending on above
#
class StopwatchTimersController < StopwatchController

  before_action :find_optional_data, only: %i(new create)
  before_action :authorize_log_time, only: %i(new create start stop current)
  before_action :find_time_entry, only: %i(edit update start stop)
  before_action :authorize_edit_time, only: %i(edit update)
  before_action :find_timer, only: %i(new edit current)

  def new
    @time_entry = new_time_entry
    load_todays_entries
  end

  def create
    @time_entry = new_time_entry
    @time_entry.safe_attributes = params[:time_entry]
    @result = Stopwatch::StartTimer.new(@time_entry).call
    unless @result.success?
      if @result.error == :unauthorized
        render_403
      else
        render_error status: 422, message: "could not start timer: #{@result.error}"
      end
    end
  end

  def edit
    @entries = load_todays_entries #.where.not(id: @time_entry.id)
  end

  def update
    @time_entry.safe_attributes = params[:time_entry]
    @success = @time_entry.save
    if !@success
      edit
    elsif params[:continue]
      new
    end
  end

  def start
    r = Stopwatch::StartTimer.new(@time_entry).call
    if r.success?
      @started_time_entry = @time_entry
    else
      logger.error "unable to start timer: #{r.error}"
    end
    new unless params[:context]
  end

  def stop
    r = Stopwatch::StopTimer.new.call
    unless r.success?
      logger.error "unable to stop timer"
    end
    new unless params[:context]
    render action: 'start'
  end

  def current
    render json: @timer.to_json
  end

  def update_form
    if id = params[:time_entry_id].presence
      @time_entry = TimeEntry.visible.find id
    else
      @time_entry = TimeEntry.new
    end
    @time_entry.safe_attributes = params[:time_entry]
  rescue ActiveRecord::RecordNotFound
    head 404
  end

  private

  def find_timer
    @timer = Stopwatch::Timer.new User.current
    @timer.update
  end

  def find_time_entry
    @time_entry = time_entries.find params[:id]
  end

  def load_todays_entries
    @entries = time_entries.where(spent_on: User.current.today).or(
      time_entries.where(id: User.current.running_time_entry_id)
    ).order(created_on: :asc)
  end

  def time_entries
    TimeEntry.where(user: User.current)
  end

  def new_time_entry
    entry = TimeEntry.new(project: @project, issue: @issue,
                          user: User.current, spent_on: User.current.today)
    if entry.respond_to?(:author=) # Redmine 4
      entry.author = User.current
    end
    entry
  end

  def find_optional_data
    if params[:issue_id].present?
      @issue = Issue.find(params[:issue_id])
      @project = @issue.project
    elsif params[:project_id].present?
      @project = Project.find(params[:project_id])
    end
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def authorize_log_time
    User.current.allowed_to?(:log_time, nil, global: true) or
      deny_access
  end

  def authorize_edit_time
    @time_entry.editable_by?(User.current) or deny_access
  end
end
