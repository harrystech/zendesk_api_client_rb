require "faraday/middleware"
require "zendesk_api/error"

module ZendeskAPI
  module Middleware
    # @private
    module Request
      # Faraday middleware to handle retry logic for idempotent requests
      # @private
      class Retry < Faraday::Middleware

        def initialize(app, options={})
          super(app)
          @logger = options[:logger]
        end

        def call(env)
          original_env = env.dup

          if original_env[:method] == (:get || :put)
            retry_if_safe(original_env)
          else
            @app.call(original_env)
          end
        end

        def retry_if_safe(env)
          retries_left = 5

          while true
            begin
              cloned_env = env.dup
              return @app.call(cloned_env)
            rescue Error::NetworkError
              @logger.info "(zendesk_api_client) Whoops! Rescued from a network error (probably a timeout)."
              if retries_left == 0
                raise
              else
                @logger.info "(zendesk_api_client) Retrying network errors #{retries_left} more times."
                retries_left -= 1
              end
            end
          end
        end

      end
    end
  end
end