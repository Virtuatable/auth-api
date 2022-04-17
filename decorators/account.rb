module Decorators
  class Account < Draper::Decorator
    delegate_all

    def to_h
      return {id: id.to_s, username: username, email: email}
    end
  end
end