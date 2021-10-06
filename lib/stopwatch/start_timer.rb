module Stopwatch
  class StartTimer

    Result = ImmutableStruct.new(:success?, :error, :started)

    def initialize(time_entry, user: User.current)
      @time_entry = time_entry
      @user = user
    end

    def call
      if @time_entry.project && !@user.allowed_to?(:log_time, @time_entry.project)
        return Result.new(error: :unauthorized)
      end


      @time_entry.hours = 0 if @time_entry.hours.nil?
      # we want to start tracking time if this is an existing time entry, or a
      # new entry with 0 hours was created.
      # new entries with hours > 0 are just saved as is.
      start_timer = !@time_entry.new_record? || @time_entry.hours == 0

      # stop currently running timer, but only when there is a chance for us
      # to succeed creating the new one.
      StopTimer.new(user: @user).call if @time_entry.valid?

      if @time_entry.save
        start_new_timer if start_timer
        return Result.new(success: true, started: start_timer)
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

  end
end
