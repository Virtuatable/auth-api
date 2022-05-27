# frozen_string_literal: true

module Helpers
  # Provides methods to create the CSRF tag in the view
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  module Csrf
    def csrf_tag
      Rack::Csrf.csrf_tag(ENV.fetch('RACK_ENV', 'development'))
    end
  end
end
