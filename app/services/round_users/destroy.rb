module RoundUsers
  class Destroy
    def initialize(round_user:, listener: Listeners::Round.new)
      @round_user = round_user
      @listener = listener
    end

    def call
      @round_user.destroy
      @listener.user_left(@round_user)
    end
  end
end
