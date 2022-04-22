module Controllers
  class Base < Core::Controllers::Base

    configure do
      set :root, File.join(File.dirname(__FILE__), '..')
      set :views, Proc.new { File.join(root, 'views') }
      set :public_folder, Proc.new { File.join(root, 'public') }
    end

    # Checks that all the given fields are provided by the user. If a field is not given
    # as a URI parameter, it renders the error template.
    # @param fields [Array<string>] the name of the fields to check the presence.
    def check_fields_presence(*fields)
      fields.each do |field|
        api_bad_request "#{field}.required" unless field_defined? field
      end
    end

    # Checks that the application from the application ID provided by the user exists
    # and that it is a premium application. If not it raises an error.
    def application
      check_fields_presence 'application_id'
      application = Core::Models::OAuth::Application.find(params['application_id'])
      api_not_found 'application_id.unknown' if application.nil?
      Decorators::Application.new(application)
    end

    def redirect_uri
      check_fields_presence 'redirect_uri'
      uri = params['redirect_uri']
      unless application.redirect_uris.include? uri.to_s.split('?').first
        api_not_found 'redirect_uri.unknown'
      end
      return URI(uri)
    end

    def account
      check_fields_presence 'username'
      account = Core::Models::Account.find_by(username: params['username'])
      api_not_found 'username.unknown' if account.nil?
      account
    end

    def check_password
      check_fields_presence 'password'
      user_pwd = BCrypt::Password.new(account.password_digest)
      api_forbidden 'password.wrong' if user_pwd != params['password']
    end

    def self.init_csrf
      # This condition is made to avoid tests failing because we don't pass CSRF token.
      if ENV['RACK_ENV'] != 'test'
        use Rack::Session::Cookie, secret: 'secret'
        use Rack::Protection::AuthenticityToken
      end
    end
  end
end