module Stopwatch
  module UserPatch
    def self.apply
      User.prepend self unless User < self
    end

    def timer_running?
      Stopwatch::Timer.new(self).running?
    end
  end
end
