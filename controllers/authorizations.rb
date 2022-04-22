# frozen_string_literal: true

module Controllers
  # This controller creates authorization codes delivered to applications
  # to access data of an already logged in user.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Authorizations < Base
    init_csrf

    post '/' do
      authorization = Core::Models::OAuth::Authorization.create(
        account: session.account,
        application: application
      )
      halt 201, { code: authorization.code }.to_json
    end
  end
end
