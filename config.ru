require 'mongoid'
Mongoid.load!('./config/mongoid.yml', 'development')

require 'core'
require 'require_all'
require 'sinatra/i18n'
require 'rack/protection'

require './lib/uri'

require './controllers/base'
require './controllers/tokens'
require './controllers/sessions'

map('/tokens') { run Controllers::Tokens.new }
map('/') { run Controllers::Sessions.new }