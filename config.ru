require 'require_all'
require 'draper'
require 'core'

Mongoid.load!('config/mongoid.yml', :development)

require './lib/uri'
require './controllers/base'

require_rel 'services/**/*.rb'
require_rel 'decorators/**/*.rb'
require_rel 'controllers/**/*.rb'

map('/applications') { run Controllers::Applications.new }
map('/authorizations') { run Controllers::Authorizations.new }
map('/sessions') { run Controllers::Sessions.new }
map('/tokens') { run Controllers::Tokens.new }
map('/') { run Controllers::Templates.new }