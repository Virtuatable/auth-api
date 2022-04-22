# frozen_string_literal: true

module Controllers
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
