module Stopwatch
  class StartTimer

    Result = ImmutableStruct.new(:success?, :error)

    def initialize(time_entry, user: User.current)
      @time_entry = time_entry
      @user = user
    end

    def call
      if @time_entry.project && @user.allowed_to?(:log_time, @time_entry.project)
        return Result.new(error: :unauthorized)
      end

      stop_existing_timer

      @time_entry.hours = 0 if @time_entry.hours.nil?

      if @time_entry.save
        start_new_timer
        return Result.new(success: true)
      else
        Rails.logger.error("could not save time entry: \n#{@time_entry.errors.inspect}")
        return Result.new(error: :invalid)
      end
    end

    private

    def start_new_timer
      timer = Timer.new @user
      timer.start @time_entry
    end

    def stop_existing_timer
      timer = Timer.new @user
      if timer.running?
        timer.stop
      end
    end

  end
end
