RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner[:mongoid].strategy = :deletion
    DatabaseCleaner[:mongoid].clean
  end
  config.after(:each) do
    DatabaseCleaner[:mongoid].clean
  end
end