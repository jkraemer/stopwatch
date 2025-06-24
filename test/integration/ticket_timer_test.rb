require File.expand_path('../test_helper', __dir__)

class TicketTimerTest < Redmine::IntegrationTest
  include ActiveJob::TestHelper

  fixtures :projects,
           :users, :email_addresses,
           :roles,
           :members,
           :member_roles,
           :trackers,
           :projects_trackers,
           :enabled_modules,
           :issue_statuses,
           :issues,
           :enumerations,
           :custom_fields,
           :custom_values,
           :custom_fields_trackers,
           :attachments

  setup do
    @issue = Issue.find 1
    @user = User.find_by_login 'jsmith'
  end

  test "should create / stop / resume timer for ticket" do
    log_user 'jsmith', 'jsmith'

    assert_not_running

    get "/issues/1"
    assert_response :success
    assert_select "div.contextual a", text: /start tracking/i
    assert_no_difference ->{TimeEntry.count} do
      post "/issues/1/timer/start", xhr: true
      assert_response :success
    end
    assert_not_running

    assert_difference ->{TimeEntry.count} do
      post "/stopwatch_timers", xhr: true, params: {
        time_entry: { issue_id: 1, activity_id: 9 }
      }
      assert_response :success
    end

    assert_running

    get "/issues/1"
    assert_select "div.contextual a", text: /stop tracking/i
    assert_no_difference ->{TimeEntry.count} do
      post "/issues/1/timer/stop", xhr: true
    end

    assert_not_running

    get "/issues/1"
    assert_select "div.contextual a", text: /start tracking/i
    assert_no_difference ->{TimeEntry.count} do
      post "/issues/1/timer/start", xhr: true
    end
    assert_response :success

    assert_running

    get "/issues/1"
    assert_select "div.contextual a", text: /stop tracking/i
    assert_no_difference ->{TimeEntry.count} do
      post "/issues/1/timer/stop", xhr: true
    end

    assert_not_running
  end

  test "should ask by default" do
    log_user 'jsmith', 'jsmith'
    TimeEntry.delete_all
    assert_no_difference ->{TimeEntry.count} do
      post "/issues/1/timer/start", xhr: true
      assert_response :ok
    end
  end

  test "should use global default actvity" do
    log_user 'jsmith', 'jsmith'
    TimeEntry.delete_all
    with_settings plugin_stopwatch: { 'default_activity' => 'system'} do
      post "/issues/1/timer/start", xhr: true
      assert_response :created
    end
    assert te = TimeEntry.last
    assert_equal 1, te.issue_id
    assert_equal 10, te.activity_id
  end

  test "should use configured default actvity" do
    log_user 'jsmith', 'jsmith'
    TimeEntry.delete_all
    with_settings plugin_stopwatch: { 'default_activity' => '9'} do
      post "/issues/1/timer/start", xhr: true
      assert_response :created
    end
    assert te = TimeEntry.last
    assert_equal 1, te.issue_id
    assert_equal 9, te.activity_id
  end

  private

  def assert_not_running
    assert_not Stopwatch::Timer.new(User.find(@user.id)).running?
  end

  def assert_running
    assert Stopwatch::Timer.new(User.find(@user.id)).running?
  end
end
