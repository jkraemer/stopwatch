require_relative '../test_helper'

class TimerTest < ActiveSupport::TestCase
  fixtures :users, :user_preferences, :time_entries

  setup do
    @user = User.find 1
    @timer = Stopwatch::Timer.new @user
    @data = @timer.send :data
    @time_entry = TimeEntry.last
  end

  test "should know wether its running" do
    refute @timer.running?
    @data[:started_at] = 5.minutes.ago
    assert @timer.running?
  end

  test "should start timer" do
    assert_nil @data[:started_at]
    @timer.start @time_entry
    assert @data[:started_at].present?
    assert_equal @time_entry.id, @data[:time_entry_id]
  end

  test "should stop timer and update time entry" do
    hours = @time_entry.hours
    @timer.start @time_entry
    @data[:started_at] = 1.hour.ago.to_i
    @timer.stop

    @time_entry.reload
    assert_equal hours + 1, @time_entry.hours
  end

  test "should update time entry" do
    hours = @time_entry.hours
    @timer.start @time_entry
    @data[:started_at] = 1.hour.ago.to_i
    @timer.update

    @time_entry.reload
    assert_equal hours + 1, @time_entry.hours
   end

  test "should save and restore" do
    hours = @time_entry.hours
    @timer.start @time_entry
    @data[:started_at] = 1.hour.ago.to_i
    @timer.save

    timer = Stopwatch::Timer.new User.find(@user.id)
    assert timer.running?
    timer.stop

    @time_entry.reload
    assert_equal hours + 1, @time_entry.hours
  end


end

