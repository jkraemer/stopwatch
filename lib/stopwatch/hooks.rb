module Stopwatch
  class Hooks < Redmine::Hook::ViewListener
    render_on :view_layouts_base_html_head,
      partial: 'stopwatch/hooks/layouts_base_html_head'
    render_on :view_layouts_base_body_bottom,
      partial: 'stopwatch/hooks/layouts_base_body_bottom'
    render_on :view_time_entries_context_menu_start,
      partial: 'stopwatch/hooks/time_entries_context_menu_start'
  end
end
