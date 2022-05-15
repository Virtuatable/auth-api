# frozen_string_literal: true

module Controllers
  # Base class for the controllers of the application, allowing for a more
  # route-focused syntax in each of them by putting shared methods here.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Base < Core::Controllers::Base
    helpers Helpers::Csrf

    configure do
      set :root, File.absolute_path(File.join(File.dirname(__FILE__), '..'))
      set :views, (proc { File.join(root, 'views') })
      set :public_folder, File.join(settings.root, 'public')
      set :protection, except: :frame_options
    end

    def applications
      check_presence 'client_id'
      application = Core::Models::OAuth::Application.find_by(client_id: params['client_id'])
      api_not_found 'client_id.unknown' if application.nil?
      Decorators::Application.new(application)
    end

    def redirect_uri
      check_presence 'redirect_uri'
      uri = params['redirect_uri']
      api_not_found 'redirect_uri.unknown' unless application.redirect_uris.include? uri.to_s.split('?').first
      URI(uri)
    end

    def session
      Decorators::Session.new(super)
    end

    def account
      check_presence 'username'
      account = Core::Models::Account.find_by(username: params['username'])
      api_not_found 'username.unknown' if account.nil?
      Decorators::Account.new(account)
    end

    def check_password
      check_presence 'password'
      user_pwd = BCrypt::Password.new(account.password_digest)
      api_forbidden 'password.wrong' if user_pwd != params['password']
    end

    def self.init_csrf
      return if ENV.fetch('RACK_ENV', 'development') == 'test'

      use Rack::Session::Cookie, secret: 'secret'
      use Rack::Csrf, raise: true
    end
  end
end
