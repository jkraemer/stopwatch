# frozen_string_literal: true

module Stopwatch
  module IssuesControllerPatch
    module Helper
      def watcher_link(issue, user)
        link = +''
        if User.current.allowed_to?(:log_time, issue.project)
          t = Stopwatch::IssueTimer.new(issue: issue)
          if t.running?
            link << IssueLinks.new(issue).stop_timer
          else
            link << IssueLinks.new(issue).start_timer
          end
        end
        link.html_safe + super
      end
    end

    def self.apply
      IssuesController.class_eval do
        helper Helper
      end
    end
  end
end
