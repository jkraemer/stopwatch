Redmine::Plugin.register :stopwatch do
  name 'Redmine Stopwatch Plugin'
  author 'Jens Krämer'
  author_url 'https://jkraemer.net/'
  description "Start/stop timer and quick access to today's time bookings for Redmine"
  version '1.0.0'

  requires_redmine version_or_higher: '5.0.0'
  settings default: {
    'default_activity' => 'always_ask',
  }, partial: 'stopwatch/settings'

  menu :account_menu, :stopwatch,
    :new_stopwatch_timer_path,
    caption: :button_log_time,
    html: { method: :get, id: 'stopwatch-menu', 'data-remote': true },
    before: :my_account,
    if: ->(*_){ User.current.logged? and User.current.allowed_to?(:log_time, nil, global: true) }
end

Stopwatch.setup
