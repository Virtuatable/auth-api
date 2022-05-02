# frozen_string_literal: true

module Services
  # This class holds operations regarding OAuth tokens
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Tokens
    include Singleton

    # Makes several checks before creating an OAuth token :
    #   1. an application exists with this client ID
    #   2. the client secret belongs to this application
    #   3. the authorization code exists
    #   4. the authorization code belongs to this application
    # If all checks are correct, there are two possibilities :
    #   1. the application is premium, thus a premium token is provided
    #   2. the application is not premium, thus a regular token is provided
    #
    # @param application [Core::Models::OAuth::Application] the application issuing
    #   the authentication query.
    # @param authorization [Core::Models::OAuth::AuthorizationCore] the code
    #   showing the application has the authorization of the user to use its data.
    #
    # @return [Decorators::Token] a token decorated with the corresponding
    #   decorator providing the to_h convenience method.
    def create(application, authorization)
      api_bad_request('client_id', 'mismatch') if authorization.application.id != application.id
      token = Core::Models::OAuth::AccessToken.create(authorization: authorization)
      Decorators::Token.new(token)
    end

    def api_bad_request(field, error)
      raise Core::Helpers::Errors::BadRequest.new(field: field, error: error)
    end
  end
end
