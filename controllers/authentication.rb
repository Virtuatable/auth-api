# frozen_string_literal: true

module Controllers
  # Base class for the controllers of the application, allowing for a more
  # route-focused syntax in each of them by putting shared methods here.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Authentication < Core::Controllers::Base
    helpers Helpers::Csrf

    if ENV.fetch('RACK_ENV', 'development') != 'test'
      use Rack::Session::Cookie, secret: 'secret'
      use Rack::Csrf, raise: true
    end

    configure do
      set :root, File.absolute_path(File.join(File.dirname(__FILE__), '..'))
      set :views, (proc { File.join(root, 'views') })
      set :public_folder, File.join(settings.root, 'public')
      set :protection, except: :frame_options
    end

    get '/applications/:client_id' do
      application = Core.svc.applications.get_by_id(**sym_params)
      halt 200, { application: application.to_h, redirect_uri: redirect_uri }.to_json
    end

    post '/authorizations' do
      api_created Core.svc.authorizations.create_from_session(**sym_params)
    end

    get '/sessions/:session_id' do
      halt 200, Core.svc.sessions.get_by_id(**sym_params).to_json
    end

    post '/sessions' do
      api_created Core.svc.sessions.create_from_credentials(**sym_params)
    end

    get '/*' do
      erb :login, locals: { ui_root: env['UI_ROOT_PATH'] }
    end

    error Rack::Csrf::InvalidCsrfToken do
      halt 403, {
        field: Rack::Csrf.field,
        header: Rack::Csrf.header,
        message: 'invalid',
        token: Rack::Csrf.token(ENV.fetch('RACK_ENV', 'development'))
      }
    end

    def redirect_uri
      check_presence 'redirect_uri'
      uri = params['redirect_uri']
      api_not_found 'redirect_uri.unknown' unless application.redirect_uris.include? uri.to_s.split('?').first
      URI(uri)
    end
  end
end
