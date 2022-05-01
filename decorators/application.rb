# frozen_string_literal: true

module Decorators
  class Application < Draper::Decorator
    delegate_all

    def to_h
      { client_id: client_id, name: name, premium: premium }
    end
  end
end
