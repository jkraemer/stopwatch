require 'redmine'
require_dependency 'stopwatch'
require 'stopwatch/hooks'

Redmine::Plugin.register :stopwatch do
  name 'Redmine Stopwatch Plugin'
  author 'Jens Krämer'
  author_url 'https://jkraemer.net/'
  description 'Adds start/stop timer functionality'
  version '0.1.0'

  requires_redmine version_or_higher: '3.4.0'

  menu :account_menu, :stopwatch,
    :new_stopwatch_timer_path,
    caption: :button_log_time,
    html: { method: :get, id: 'stopwatch-toggle', 'data-remote': true },
    before: :my_account,
    if: ->(*_){ User.current.logged? }
end

Rails.configuration.to_prepare do
  Stopwatch::UserPatch.apply
end

