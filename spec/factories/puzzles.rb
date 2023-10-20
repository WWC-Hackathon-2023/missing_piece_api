# frozen_string_literal: true

FactoryBot.define do
  factory :puzzle do
    title { Faker::Mountain.name }
    description { Faker::Hipster.sentence }
    puzzle_image_url { Faker::Internet.url(host: 'aws-s3') }

    total_pieces do
      [260, 500, 1000, 1500, 2000, 3000].sample
    end

    association :user
  end
end
