# frozen_string_literal: true

require 'require_all'
require 'draper'
require 'core'
require 'dotenv/load'
require 'bcrypt'

Dotenv.load

Mongoid.load!('config/mongoid.yml', ENV['RACK_ENV'].to_sym || :development)

require './lib/uri'
require './controllers/base'

require_rel 'services/**/*.rb'
require_rel 'decorators/**/*.rb'
require_rel 'controllers/**/*.rb'

root = ENV['UI_ROOT_PATH'] || ''

map("#{root}/applications") { run Controllers::Applications.new }
map("#{root}/authorizations") { run Controllers::Authorizations.new }
map("#{root}/sessions") { run Controllers::Sessions.new }
map("#{root}/tokens") { run Controllers::Tokens.new }
map("#{root}/ui") { run Controllers::Templates.new }
map('/') { run Controllers::Base.new }