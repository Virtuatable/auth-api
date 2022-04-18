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
        error 400, "#{field}.required" unless field_defined? field
      end
    end

    # Checks that the application from the application ID provided by the user exists
    # and that it is a premium application. If not it raises an error.
    def application
      check_fields_presence 'application_id'
      application = Core::Models::OAuth::Application.find(params['application_id'])
      error 404, 'application_id.unknown' if application.nil?
      Decorators::Application.new(application)
    end

    def redirect_uri
      check_fields_presence 'redirect_uri'
      uri = URI(params['redirect_uri'])
      unless application.redirect_uris.include? uri.to_s.split('?').first
        error 404, 'redirect_uri.unknown'
      end
      uri
    end

    def account
      check_fields_presence 'username'
      account = Core::Models::Account.find_by(username: params['username'])
      error 404, 'username.unknown' if account.nil?
      user_pwd = BCrypt::Password.new(account.password_digest)
      error 403, 'password.wrong' if user_pwd != params['password']
      account
    end
  end
end