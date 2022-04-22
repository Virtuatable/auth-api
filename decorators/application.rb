# frozen_string_literal: true

module Decorators
  class Application < Draper::Decorator
    delegate_all

    def to_h
      { id: id.to_s, name: name, premium: premium }
    end
  end
end
