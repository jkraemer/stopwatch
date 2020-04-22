class StopwatchTimersController < ApplicationController
  helper :timelog

  before_action :require_login
  before_action :find_optional_data, only: %i(new create)

  def new
    @time_entry = new_time_entry
    respond_to :js
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

  end

  def update

  end

  private

  def new_time_entry
    TimeEntry.new(project: @project, issue: @issue,
                  user: User.current, spent_on: User.current.today)
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

end
