# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'faker'

# Create users
10.times do
  password = Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3)

  User.create(
    full_name: Faker::Name.name,
    password:,
    password_confirmation: password,
    email: Faker::Internet.email,
    zip_code: Faker::Address.zip_code,
    phone_number: Faker::PhoneNumber.phone_number
  )
end

# Create puzzles
total_pieces_options = [260, 500, 1000, 1500, 2000, 3000]
puzzle_status_options = [0, 1, 2]
puzzle_urls = [
  "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953702/Wild_Beauty_mwbteq.jpg",
  "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953702/Trailerama_rep7ob.jpg",
  "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953701/The_Arrangement_by_Erin_Wert_xs8dae.jpg",
  "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953701/The_Old_Tractor_utq9ji.jpg",
  "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953701/The_Poppy_Field_aoeqvd.jpg",
  "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953701/Readers_Paradise_yzuufl.jpg",
  "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953701/Snowmen_sqjoi8.jpg",
  "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953699/Ravensburger_Puzzle_b7lvkv.jpg",
  "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953699/Sherlock_Holmes_xmi91o.jpg",
  "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953699/Perennials_ly33vr.jpg",
  "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953699/Flowers_Italy_by_Joseph_Stella_va3dal.jpg",
  "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953698/In_Gooood_f1lnlq.jpg",
  "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953698/Hummingbird_and_Flowers_re6j81.jpg",
  "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953697/Harvest_Moon_Ball_nfmlff.jpg",
  "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953697/Country_Farm_Life_upjwn7.jpg",
  "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953696/country_blessings_zggvlw.jpg",
  "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953696/Friends_in_Winter_idgv3a.jpg",
  "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953696/Buffalo_misvis.jpg",
  "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953696/Bird_a7i5v9.jpg",
  "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697931336/Maroon_Lake_frszdv.jpg",
  "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697931322/Durango_Silverton_pkiqbm.jpg",
  "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697931301/Mountain_Chalet_voncs7.jpg",
  "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697928739/yuhdpbgsunky4mrphza0.jpg"
]

30.times do
  Puzzle.create(
    user_id: User.pluck(:id).sample,
    title: Faker::Lorem.words(number: 3).join(' '),
    description: Faker::Lorem.sentence,
    total_pieces: total_pieces_options.sample,
    notes: Faker::Lorem.paragraph,
    puzzle_image_url: puzzle_urls.sample,
    status: puzzle_status_options.sample
  )
end

# Create loans
loan_status_options = [0, 1, 2, 3]

20.times do
  owner = User.order("RANDOM()").first # Select a random owner
  borrower = User.order("RANDOM()").first # Select a random borrower
  puzzle = owner.puzzles.sample # Select a puzzle owned by the owner

  Loan.create(
    owner_id: owner.id,
    borrower_id: borrower.id,
    puzzle_id: puzzle.id,
    status: loan_status_options.sample
  )
end
