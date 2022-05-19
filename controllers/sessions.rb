# frozen_string_literal: true

module Controllers
  # This controller holds actions regarding sessions, whether you want to
  # create new ones, or to check that existing ones really exist.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Sessions < Controllers::Base
    init_csrf

    get '/:session_id' do
      halt 200, Core.svc.sessions.get_by_id(**sym_params).to_json
    end

    post '/' do
      api_created Core.svc.sessions.create_from_credentials(**sym_params)
    end
  end
end
