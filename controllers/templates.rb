module Controllers
  class Templates < Base

    init_csrf

    get '/*' do
      erb :login, locals: {csrf_token: env['rack.session'][:csrf]}
    end
  end
end