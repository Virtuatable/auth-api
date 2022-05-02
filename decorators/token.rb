module Decorators
  class Token < Draper::Decorator
    delegate_all

    def to_json
      to_h.to_json
    end

    def to_h
      {token: object.value}
    end
  end
end