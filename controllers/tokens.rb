module Controllers
  class Tokens < Controllers::Base

    post '/' do
      check_fields_presence 'authorization_code', 'application_id'
      token = Core::Models::OAuth::AccessToken.create(
        authorization: authorization
      )
      api_created({token: token.value})
    end

    def error(code, translation)
      api_error code, translation
    end

    def authorization
      authorization = Core::Models::OAuth::Authorization.find_by(
        code: params['authorization_code']
      )
      if authorization.nil?
        api_not_found 'authorization_code.unknown'
      end
      if authorization.application.id != application.id
        api_bad_request 'application_id.mismatch'
      end
      authorization
    end
  end
end