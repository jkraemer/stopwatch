require_relative '../test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users, :user_preferences, :issues

  setup do
    @user = User.find 1
  end

  test "should get inactive timer state" do
    refute @user.timer_running?
  end

  test "should start timer and get running state" do
    t = Stopwatch::Timer.new @user
    t.start
    t.save
    assert @user.timer_running?
  end

  test "should build time entry for issue" do
    i = Issue.find 1
    te = @user.todays_time_entry_for i
    assert te.new_record?
    assert_equal @user, te.user
    assert_equal i, te.issue
    assert_equal @user.today, te.spent_on
  end

end
