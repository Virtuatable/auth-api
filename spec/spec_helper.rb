require 'mongoid'
Mongoid.load!('./config/mongoid.yml', 'development')

require 'core'
require 'require_all'
require 'rack/test'

require_rel '../controllers/**/*.rb'
require_rel 'support/**/*.rb'