module Riot
  class Api::RateLimit
    attr_accessor :limit, :count, :interval, :expires_at

    def initialize(limit:, count:, interval:)
      @limit = limit
      @count = count
      @interval = interval
      @expires_at = Time.now + interval.seconds
    end

    def wait_for
      (@expires_at - Time.now).abs
    end

    def limited?
      !expired? && @count >= @limit
    end

    def expired?
      expires_at.past?
    end

    def increment
      @count += 1
    end
  end
end
