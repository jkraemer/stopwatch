require_relative '../test_helper'

class StartTimerTest < ActiveSupport::TestCase
  fixtures :users, :user_preferences, :time_entries, :projects,
    :roles, :member_roles, :members, :enumerations

  setup do
    @user = User.find 1
    @time_entry = TimeEntry.last
  end

  test "should start timer" do
    refute User.find(@user.id).timer_running?
    assert r = Stopwatch::StartTimer.new(@time_entry, user: @user).call
    assert r.success?, r.inspect
    assert User.find(@user.id).timer_running?
  end

  test "should stop and save existing timer" do
    hours = @time_entry.hours
    r = Stopwatch::StartTimer.new(@time_entry, user: @user).call
    assert r.success?
    t = Stopwatch::Timer.new(@user)
    data = t.send(:data)
    data[:started_at] = 1.hour.ago.to_i
    t.save

    @time_entry.reload
    assert_equal hours, @time_entry.hours
    another = TimeEntry.new(@time_entry.attributes)
    another.user = @user
    r = Stopwatch::StartTimer.new(another, user: @user).call
    assert r.success?
    @time_entry.reload
    assert_equal hours+1, @time_entry.hours
  end

end


