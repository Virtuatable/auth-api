require 'require_all'
require 'draper'
require 'core'

Mongoid.load!('config/mongoid.yml', :development)

require './lib/uri'

require_rel 'services/**/*.rb'
require_rel 'decorators/**/*.rb'
require_rel 'controllers/**/*.rb'

map('/') { run Controllers::Sessions.new }