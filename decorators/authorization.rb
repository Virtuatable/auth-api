# frozen_string_literal: true

module Decorators
  class Authorization < Draper::Decorator
    delegate_all

    def to_h
      {
        code: code,
        application: {
          id: application.id.to_s,
          name: application.name,
          premium: application.premium
        }
      }
    end

    def account
      Decorators::Account.new(object.account)
    end
  end
end
