# frozen_string_literal: true

module Controllers
  # This controller holds the action to transform an authorization code into
  # a usable access token that will be passed to the API.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Tokens < Base
    post '/' do
      api_created Services::Tokens.instance.create(application, authorization)
    end

    def application
      check_presence 'client_id', 'client_secret'
      api_bad_request 'client_secret.wrong' if super.client_secret != params['client_secret']
      super
    end

    def authorization
      check_presence 'authorization_code'
      authorization = Core::Models::OAuth::Authorization.find_by(
        code: params['authorization_code']
      )
      api_not_found 'authorization_code.unknown' if authorization.nil?
      authorization
    end
  end
end
