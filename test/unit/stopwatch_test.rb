require_relative '../test_helper'

class StopwatchTest < ActiveSupport::TestCase
  fixtures :projects, :enabled_modules, :enumerations

  setup do
    @project = Project.find 'ecookbook'
    @te = TimeEntry.new project: @project
  end

  test "default value for default_activity" do
    assert_equal 'always_ask', Stopwatch.default_activity
  end

  test "should find default activity" do
    with_settings plugin_stopwatch: { 'default_activity' => 9} do
      assert_equal 'Design', Stopwatch.default_activity.name
    end
    with_settings plugin_stopwatch: { 'default_activity' => '11'} do
      assert_equal 'QA', Stopwatch.default_activity.name
    end
  end

  ### 'system' -> ask if there is no sys default / more than one availabale activity

  test "should use system default activity for te" do
    with_settings plugin_stopwatch: { 'default_activity' => 'system' } do
      assert_equal 'Development', Stopwatch.default_activity_for(@te).name
    end
  end

  test "should use single active project activity for time entry" do
    with_settings plugin_stopwatch: { 'default_activity' => 'system' } do
      TimeEntryActivity.create! active: false, project: @project, name: 'Development', parent_id: 10
      TimeEntryActivity.create! active: false, project: @project, name: 'QA', parent_id: 11
      assert_equal 'Design', Stopwatch.default_activity_for(@te).name
    end
  end

  test "should ask if more than one and no default" do
    with_settings plugin_stopwatch: { 'default_activity' => 'system' } do
      TimeEntryActivity.update_all is_default: false
      assert_nil Stopwatch.default_activity_for(@te)
    end
  end

  ### always_ask (the default)

  test "should return nil if always ask is set" do
    assert_nil Stopwatch.default_activity_for(@te)

    TimeEntryActivity.create! active: false, project: @project, name: 'Development'
    assert_nil Stopwatch.default_activity_for(@te)

    TimeEntryActivity.where(name: 'Development').delete_all
    assert_nil Stopwatch.default_activity_for(@te)
  end

  ### specific activity -> ask only if this is not available in project

  test "should use configured default activity for time entry" do
    with_settings plugin_stopwatch: { 'default_activity' => '9' } do
      assert_equal 'Design', Stopwatch.default_activity_for(@te).name
    end
  end

  test "should not have default if unavailable" do
    TimeEntryActivity.create! active: false, project: @project, name: 'Design', parent_id: 9
    TimeEntryActivity.create! active: false, project: @project, name: 'Development', parent_id: 11
    assert_equal [10], @project.activities.pluck(:id)

    with_settings plugin_stopwatch: { 'default_activity' => '9'} do
      assert_nil Stopwatch.default_activity_for(@te)
    end
  end

end

