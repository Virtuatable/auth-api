FactoryBot.define do
  factory :empty_application, class: Core::Models::OAuth::Application do
    factory :application do
      name { 'My wonderful test application' }
      redirect_uris { [ Faker::Internet.url ] }
    end
  end
end