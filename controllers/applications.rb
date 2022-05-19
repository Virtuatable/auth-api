# frozen_string_literal: true

module Controllers
  # This controller holds actions regarding the checks chether an application
  # exists or not, and that the provided redirect URI is associated to it.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Applications < Base
    get '/:client_id' do
      application = Core.svc.applications.get_by_id(**sym_params)
      halt 200, { application: application.to_h, redirect_uri: redirect_uri }.to_json
    end
  end
end
