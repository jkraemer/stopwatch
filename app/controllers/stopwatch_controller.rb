# base class for stopwatch controllers
class StopwatchController < ApplicationController
  helper :timelog, :custom_fields

  before_action :require_login

  private

  def authorize_edit_time
    @time_entry.editable_by?(User.current) or deny_access
  end
end
