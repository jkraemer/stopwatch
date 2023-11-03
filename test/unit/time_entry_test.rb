require File.expand_path('../../test_helper', __FILE__)

class StartTimerTest < ActiveSupport::TestCase
  fixtures :users, :user_preferences, :time_entries, :projects,
    :roles, :member_roles, :members, :enumerations, :enabled_modules

  setup do
    @user = User.find 1
    @time_entry = TimeEntry.where(user_id: 1).first
    # so we dont have to load all the issue and related fixtures:
    @time_entry.update_column :issue_id, nil
  end

  test "should stop timer before destroy" do
    assert r = Stopwatch::StartTimer.new(@time_entry, user: @user).call
    assert r.success?, r.inspect
    assert User.find(@user.id).timer_running?

    @time_entry.destroy

    refute User.find(@user.id).timer_running?
  end

end
