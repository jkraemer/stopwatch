require_relative '../test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users, :user_preferences

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

end
