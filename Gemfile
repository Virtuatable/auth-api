source 'https://rubygems.org/'

group :development, :production, :test do
  gem 'virtuatable-core', require: 'core'
  gem 'require_all'
  gem 'draper'
end

group :development, :production do
  gem 'puma'
end

group :development, :test do
  gem 'pry'
end

group :test do
  gem 'rspec'
  gem 'rspec-json_expectations'
  gem 'factory_bot'
  gem 'rack-test', require: 'rack/test'
  gem 'faker'
  gem 'database_cleaner-mongoid'
end