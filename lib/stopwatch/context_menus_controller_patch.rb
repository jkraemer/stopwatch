# frozen_string_literal: true

module Stopwatch
  module ContextMenusControllerPatch
    module Helper
      def watcher_link(objects, user)
        link = +''
        if params[:action] == 'issues' and
            objects.one? and (issue = objects[0]).is_a?(Issue) and
            User.current.allowed_to?(:log_time, issue.project)
          t = Stopwatch::IssueTimer.new(issue: issue)
          if t.running?
            link << IssueLinks.new(issue, self).stop_timer
          else
            link << IssueLinks.new(issue, self).start_timer
          end
        end
        super + content_tag(:li, link.html_safe)
      end
    end

    def self.apply
      ContextMenusController.class_eval do
        helper Helper
      end
    end
  end
end
