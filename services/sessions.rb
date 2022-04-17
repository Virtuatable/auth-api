require 'securerandom'

module Services
  # This service allows the creation of session to authenticate the user on the application.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Sessions
    include Singleton

    # Creates a session for the given user so that we know he's authenticated.
    # @param account {Core::Models::Account} the account to create a session for.
    # @return [Core::Models::Authentication::Session] the created session
    def create(account)
      session = Core::Models::Authentication::Session.create(
        account:account,
        token: SecureRandom.hex
      )
      Decorators::Session.new(session).to_h
    end
  end
end