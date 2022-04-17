module Decorators
  class Application < Draper::Decorator
    delegate_all

    def to_h
      return {id: id.to_s, name: name, premium: premium}
    end
  end
end