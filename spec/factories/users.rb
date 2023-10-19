FactoryBot.define do
  factory :user do
    full_name { Faker::Name.name }
    email { Faker::Internet.safe_email }
     #we are using US zip codes for MVP: only 5 digits
    zip_code { Faker::Number.number(digits: 5) }
     #We are using US examples for the MVP: this will need to change for international usage
     #We format all phone numbers before saving them in the database
    phone_number { "(#{Faker::Number.number(digits: 3)}) #{Faker::Number.number(digits: 3)}-#{Faker::Number.number(digits: 4)}" }
    user_image_url { Faker::Internet.url(host: 'aws-s3') }
  end
end