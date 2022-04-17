module Controllers
  class Sessions < Controllers::Base

    use Rack::Session::Cookie, secret: 'secret'
    use Rack::Protection::AuthenticityToken

    get '/*' do
      erb :login, locals: {csrf_token: env['rack.session'][:csrf]}
    end

    post '/sessions' do
      check_fields_presence 'username', 'password', 'redirect_uri', 'application_id'
      uri = check_redirect_uri(application, params['redirect_uri'])
      session = Services::Sessions.instance.create(account)
      if application.premium
        authorization = Services::Authorizations.instance.create(account, application)
        uri.add_param('authorization_code', authorization[:code])
        halt 201, {
          session: session,
          authorization: authorization,
          redirect_uri: uri,
          application: application.to_h
        }.to_json
      else
        halt 201, {
          session: session,
          application: application.to_h
        }.to_json
      end
    end

    def error(code, translation)
      api_error code, translation
    end

    def check_response_type
      error 400, 'response_type.value' if params['response_type'] != 'code'
    end
  end
end