# frozen_string_literal: true

module Controllers
  # This controller holds the action to transform an authorization code into
  # a usable access token that will be passed to the API.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Tokens < Base
    post '/' do
      token = Core::Models::OAuth::AccessToken.create(authorization: authorization)
      api_created({ token: token.value })
    end

    def authorization
      check_presence 'authorization_code'
      authorization = Core::Models::OAuth::Authorization.find_by(
        code: params['authorization_code']
      )
      api_not_found 'authorization_code.unknown' if authorization.nil?
      api_bad_request 'client_id.mismatch' if authorization.application.id != application.id
      authorization
    end
  end
end
