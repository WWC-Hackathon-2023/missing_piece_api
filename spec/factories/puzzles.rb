FactoryBot.define do
  factory :puzzle do
    user { nil }
    status { 1 }
    title { "MyString" }
    description { "MyString" }
    total_pieces { 1 }
    notes { "MyString" }
    puzzle_image_url { "MyString" }
  end
end
