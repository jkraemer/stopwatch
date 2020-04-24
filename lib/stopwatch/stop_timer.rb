module Stopwatch
  class StopTimer

    Result = ImmutableStruct.new(:success?, :error)

    def initialize(user: User.current)
      @user = user
    end

    def call
      timer = Timer.new @user
      if timer.running?
        timer.stop
      end
      return Result.new(success: true)
    end

  end
end

