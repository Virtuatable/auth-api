# frozen_string_literal: true

module Controllers
  # This controller renders the JS application as static files.
  # @todo : put the files on an S3 or any external storage
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Templates < Base
    helpers Helpers::Csrf

    init_csrf

    configure do
      set :protection, except: :frame_options
    end

    get '/*' do
      erb :login, locals: {
        ui_root: env['UI_ROOT_PATH']
      }
    end
  end
end
