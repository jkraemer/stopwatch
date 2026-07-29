module Stopwatch
  class Hooks < Redmine::Hook::ViewListener
    render_on :view_layouts_base_html_head,
      partial: 'stopwatch/hooks/layouts_base_html_head'
    render_on :view_layouts_base_body_bottom,
      partial: 'stopwatch/hooks/layouts_base_body_bottom'
    render_on :view_time_entries_context_menu_start,
      partial: 'stopwatch/hooks/time_entries_context_menu_start'

    # This hook is natively provided by Redmine 7's issues context menu view
    def view_issues_context_menu_start(context = {})
      issues = context[:issues]
      
      # We only append our element if exactly one issue is highlighted
      return '' unless issues&.one?

      issue = issues.first
      return '' unless User.current.allowed_to?(:log_time, issue.project)

      # 'controller' in this context gives access to view helper context
      view = context[:controller].view_context
      timer = Stopwatch::IssueTimer.new(issue: issue)
      
      link = if timer.running?
               IssueLinks.new(issue, view).stop_timer
             else
               IssueLinks.new(issue, view).start_timer
             end

      view.content_tag(:li, link.html_safe)
    end
  end
end
