require 'stopwatch/hooks'

Redmine::Plugin.register :stopwatch do
  name 'Redmine Stopwatch Plugin'
  author 'Jens Krämer'
  author_url 'https://jkraemer.net/'
  description "Start/stop timer and quick access to today's time bookings for Redmine"
  version '0.1.0'

  requires_redmine version_or_higher: '3.4.0'

  menu :account_menu, :stopwatch,
    :new_stopwatch_timer_path,
    caption: :button_log_time,
    html: { method: :get, id: 'stopwatch-menu', 'data-remote': true },
    before: :my_account,
    if: ->(*_){ User.current.logged? and User.current.allowed_to?(:log_time, nil, global: true) }
end

Rails.configuration.to_prepare do
  Stopwatch::UserPatch.apply
end

