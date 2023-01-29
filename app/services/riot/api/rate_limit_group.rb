# frozen_string_literal: true

module Riot
  class Api::RateLimitGroup
    def initialize(use_app_headers: false)
      @use_app_headers = use_app_headers
      @limits = []
      @mutex = Mutex.new
    end

    def request
      @mutex.synchronize do
        update_limits
        wait_until_free
        @limits.each(&:increment)
      end
    end

    def add_limits_from_response(response:)
      @mutex.synchronize do
        update_limits
        response[limit_header].split(",").zip(response[count_header].split(",")).each do |limit_string, count_string|
          limit, interval = limit_string.split(":").map(&:to_i)
          count = count_string.split(":").first.to_i
          existing_limit = @limits.find { |limit| limit.interval == interval }
          if existing_limit.nil?
            @limits << Api::RateLimit.new(limit: limit, count: count, interval: interval)
          else
            existing_limit.count = count
          end
        end
      end
    end

    def pause_requests(duration:)
      @mutex.synchronize do
        @limits << Api::RateLimit.new(limit: 0, count: 0, interval: duration)
      end
    end

    private

    def wait_until_free
      sleep(@limits.filter(&:limited?).max_by(&:wait_for)) if limited?
    end

    def limit_header
      @use_app_headers ? "X-App-Rate-Limit" : "X-Method-Rate-Limit"
    end

    def count_header
      @use_app_headers ? "X-App-Rate-Limit-Count" : "X-Method-Rate-Limit-Count"
    end

    def update_limits
      @limits.reject!(&:expired?)
    end

    def limited?
      @limits.any?(&:limited?)
    end
  end
end
