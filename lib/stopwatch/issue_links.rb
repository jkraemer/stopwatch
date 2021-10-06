module Stopwatch
  class IssueLinks < Struct.new(:issue)
    include ActionView::Helpers::UrlHelper
    include Rails.application.routes.url_helpers


    def start_timer
      link_to(I18n.t(:label_stopwatch_start),
              start_issue_timer_path(issue),
              class: 'icon icon-time stopwatch_issue_timer',
              data: { issue_id: issue.id },
              remote: true,
              method: 'post')
    end

    def stop_timer
      link_to(I18n.t(:label_stopwatch_stop),
              stop_issue_timer_path(issue),
              class: 'icon icon-time stopwatch_issue_timer',
              data: { issue_id: issue.id },
              remote: true,
              method: 'post')

    end

    # to make route helpers happy
    def controller; nil end
  end
end
