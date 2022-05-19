# frozen_string_literal: true

module Controllers
  # This controller creates authorization codes delivered to applications
  # to access data of an already logged in user.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Authorizations < Base
    init_csrf

    post '/' do
      api_created Core.svc.authorizations.create_from_session(**sym_params)
    end
  end
end
