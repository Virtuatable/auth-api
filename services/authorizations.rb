module Services
  class Authorizations
    include Singleton

    def create (account, application)
      authorization = Core::Models::OAuth::Authorization.create(
        account: account,
        application: application
      )
      Decorators::Authorization.new(authorization).to_h
    end
  end
end