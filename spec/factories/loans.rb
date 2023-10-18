FactoryBot.define do
  factory :loan do
    association :borrower, factory: :user
    association :owner, factory: :user
    puzzle { |loan| loan.owner.puzzles.sample }
  end
end