module Helpers
  module Csrf
    def csrf_tag
      Rack::Csrf.csrf_tag(env)
    end
  end
end