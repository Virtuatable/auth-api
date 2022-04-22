# frozen_string_literal: true

module Controllers
  class Applications < Base
    get '/:application_id' do
      halt 200, { application: application.to_h, redirect_uri: redirect_uri }.to_json
    end
  end
end
