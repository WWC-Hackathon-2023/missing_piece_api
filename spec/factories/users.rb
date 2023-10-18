FactoryBot.define do
  factory :user do
    full_name { Faker::Name.name }
    email { Faker::Internet.safe_email }
    zip_code { Faker::Number.number(digits: 5) } #we are using US zip codes as our example data - only 5 digits
    phone_number { Faker::PhoneNumber.cell_phone.gsub(/(\d{3})(\d{3})(\d{4})/, '(\1) \2-\3') } #we format all phone numbers before saving them in the database
    user_image_url { Faker::Internet.url(host: 'aws-s3') }
  end
end