FactoryBot.define do
  factory :user do
    full_name { "MyString" }
    password_digest { "MyString" }
    email { "MyString" }
    zip_code { 1 }
    phone_number { "MyString" }
    user_image_url { "MyString" }
  end
end
