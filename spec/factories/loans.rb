FactoryBot.define do
  factory :loan do
    owner_id { nil }
    borrower_id { nil }
    puzzle_id { nil }
    status { 1 }
  end
end
