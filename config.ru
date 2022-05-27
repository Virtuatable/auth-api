# frozen_string_literal: true

require 'require_all'
require 'draper'
require 'core'
require 'dotenv/load'
require 'bcrypt'
require 'rack/csrf'

Dotenv.load

Mongoid.load!('config/mongoid.yml', ENV['RACK_ENV'].to_sym || :development)

require './helpers/csrf'
require './lib/uri'
require './controllers/authentication'

root = ENV.fetch('UI_ROOT_PATH', nil) || '/'
map("#{root}") { run Controllers::Authentication.new }