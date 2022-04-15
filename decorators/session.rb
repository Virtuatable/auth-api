module Decorators
  class Session < Draper::Decorator
    delegate_all

    def to_h
      return {
        token: token,
        account_id: account.id.to_s,
        created_at: created_at.iso8601
      }
    end

    def account
      Decorators::Account.new(object.account)
    end
  end
end