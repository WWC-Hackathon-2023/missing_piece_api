# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require ='faker'

# Create users
10.times do
    User.create(
      full_name: Faker::Name.name,
      password_digest: BCrypt::Password.create('password'), # You may want to set a secure password here
      email: Faker::Internet.email,
      zip_code: Faker::Address.zip_code,
      phone_number: Faker::PhoneNumber.phone_number,
      user_image_url: Faker::Avatar.image
    )
  end
  
  # Create puzzles
  10.times do
    Puzzle.create(
      user_id: User.pluck(:id).sample,
      status: [0, 1, 2].sample, # Replace with your puzzle status values
      title: Faker::Lorem.words(number: 3).join(' '),
      description: Faker::Lorem.sentence,
      total_pieces: Faker::Number.between(from: 10, to: 100),
      notes: Faker::Lorem.paragraph,
      puzzle_image_url: Faker::Internet.url
    )
  end
  
  # Create loans
  10.times do
    Loan.create(
      owner_id: User.pluck(:id).sample,
      borrower_id: User.pluck(:id).sample,
      puzzle_id: Puzzle.pluck(:id).sample,
      status: [0, 1, 2].sample, # Replace with your loan status values
      created_at: Faker::Time.between(from: 1.year.ago, to: Time.now),
      updated_at: Faker::Time.between(from: 1.year.ago, to: Time.now)
    )
  end