module Controllers
  class Sessions < Controllers::Base

    use Rack::Session::Cookie, secret: 'secret'
    use Rack::Protection::AuthenticityToken

    # This displays the log in form for the user to identify on the
    # application and create a session on our side.
    get '/sessions' do
      check_fields_presence 'application_id', 'redirect_uri', 'response_type'
      check_response_type
      erb :login, locals: {
        application_id: application.id,
        redirect_uri: check_redirect_uri(application, params[:redirect_uri])
      }
    end

    post '/sessions' do
      check_fields_presence 'username', 'password', 'redirect_uri', 'application_id'
      uri = check_redirect_uri(application, params['redirect_uri'])
      authorization = Core::Models::OAuth::Authorization.create(
        account: account,
        application: application
      )
      uri.add_param('access_code', authorization.code)
      redirect uri.to_s
    end

    get '/*' do
      File.read(File.join(settings.public_folder, 'index.html'))
    end

    def error(code, translation)
      halt code, (erb :error, locals: {error: t(translation)})
    end

    def check_response_type
      error 400, 'response_type.value' if params['response_type'] != 'code'
    end
  end
end