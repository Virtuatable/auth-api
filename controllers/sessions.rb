# frozen_string_literal: true

module Controllers
  class Sessions < Controllers::Base
    init_csrf

    get '/:session_id' do
      return 200, Decorators::Session.new(session).to_h.to_json
    end

    post '/' do
      check_password
      halt 201, { session: Services::Sessions.instance.create(account) }.to_json
    end
  end
end
