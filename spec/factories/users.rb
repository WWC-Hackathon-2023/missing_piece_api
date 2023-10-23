# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    full_name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3) }

    # Set password_confirmation to the same value as password
    password_confirmation { |user| user.password }

    # we are using US zip codes for MVP: only 5 digits
    zip_code { Faker::Number.number(digits: 5) }

    # We are using US examples for the MVP: this will need to change for international usage
    # We format all phone numbers before saving them in the database
    # phone_number { Faker::Number.number(digits: 10) }
    phone_number { "(#{Faker::Number.number(digits: 3)}) #{Faker::Number.number(digits: 3)}-#{Faker::Number.number(digits: 4)}" }

    # Decided not to use this and go with an icon on the FE repo
    # user_image_url { Faker::Internet.url(host: 'aws-s3') }
  end
end
