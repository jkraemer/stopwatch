module Stopwatch
  class IssueLinks < Struct.new(:issue, :context)
    def start_timer
      context.link_to(
        context.sprite_icon(:time, I18n.t(:label_stopwatch_start)),
        context.start_issue_timer_path(issue),
        class: 'stopwatch_issue_timer',
        data: { issue_id: issue.id },
        remote: true,
        method: 'post'
      )
    end

    def stop_timer
      context.link_to(
        context.sprite_icon(:time, I18n.t(:label_stopwatch_stop)),
        context.stop_issue_timer_path(issue),
        class: 'stopwatch_issue_timer',
        data: { issue_id: issue.id },
        remote: true,
        method: 'post'
      )
    end

    # to make route helpers happy
    def controller; nil end
  end
end
