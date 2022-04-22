module Controllers
  class Sessions < Controllers::Base

    use Rack::Session::Cookie, secret: 'secret'
    use Rack::Protection::AuthenticityToken

    get '/sessions/:session_id' do
      return 200, Decorators::Session.new(session).to_h.to_json
    end

    get '/*' do
      erb :login, locals: {csrf_token: env['rack.session'][:csrf]}
    end

    post '/app-check' do
      halt 200, {application: application.to_h, redirect_uri: redirect_uri}.to_json
    end

    post '/authorizations' do
      session
      authorization = Core::Models::OAuth::Authorization.create(
        account: session.account,
        application: application
      )
      halt 201, {code: authorization.code}.to_json
    end

    post '/sessions' do
      check_fields_presence 'password'
      session = Services::Sessions.instance.create(account)
      if application.premium
        authorization = Services::Authorizations.instance.create(account, application)
        halt 201, {
          session: session.to_h,
          authorization: authorization
        }.to_json
      else
        halt 201, {session: session}.to_json
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