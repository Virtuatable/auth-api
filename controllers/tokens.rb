# frozen_string_literal: true

module Controllers
  class Tokens < Base
    init_csrf

    post '/' do
      token = Core::Models::OAuth::AccessToken.create(authorization: authorization)
      api_created({ token: token.value })
    end

    def authorization
      check_fields_presence 'authorization_code'
      authorization = Core::Models::OAuth::Authorization.find_by(
        code: params['authorization_code']
      )
      api_not_found 'authorization_code.unknown' if authorization.nil?
      api_bad_request 'application_id.mismatch' if authorization.application.id != application.id
      authorization
    end
  end
end
