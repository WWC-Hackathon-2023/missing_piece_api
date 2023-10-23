# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# require 'faker'

####### Create users
# zip_code_options = [12345, 54321, 10101, 55055]
# 5.times do
#   password = Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3)

#   User.create(
#     full_name: Faker::Name.name,
#     password: password,
#     password_confirmation: password,
#     email: Faker::Internet.email,
#     zip_code: zip_code_options.sample,
#     phone_number: "(#{Faker::Number.number(digits: 3)}) #{Faker::Number.number(digits: 3)}-#{Faker::Number.number(digits: 4)}"
#   )
# end
###### Create puzzles
# total_pieces_options = [260, 500, 1000, 1500, 2000, 3000]
# puzzle_status_options = [0, 1, 2]
# puzzle_urls = [
#   "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953702/Wild_Beauty_mwbteq.jpg",
#   "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953702/Trailerama_rep7ob.jpg",
#   "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953701/The_Arrangement_by_Erin_Wert_xs8dae.jpg",
#   "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953701/The_Old_Tractor_utq9ji.jpg",
#   "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953701/The_Poppy_Field_aoeqvd.jpg",
#   "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953701/Readers_Paradise_yzuufl.jpg",
#   "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953701/Snowmen_sqjoi8.jpg",
#   "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953699/Ravensburger_Puzzle_b7lvkv.jpg",
#   "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953699/Sherlock_Holmes_xmi91o.jpg",
#   "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953699/Perennials_ly33vr.jpg",
#   "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953699/Flowers_Italy_by_Joseph_Stella_va3dal.jpg",
#   "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953698/In_Gooood_f1lnlq.jpg",
#   "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953698/Hummingbird_and_Flowers_re6j81.jpg",
#   "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953697/Harvest_Moon_Ball_nfmlff.jpg",
#   "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953697/Country_Farm_Life_upjwn7.jpg",
#   "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953696/country_blessings_zggvlw.jpg",
#   "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953696/Friends_in_Winter_idgv3a.jpg",
#   "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953696/Buffalo_misvis.jpg",
#   "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953696/Bird_a7i5v9.jpg",
#   "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697931336/Maroon_Lake_frszdv.jpg",
#   "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697931322/Durango_Silverton_pkiqbm.jpg",
#   "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697931301/Mountain_Chalet_voncs7.jpg",
#   "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697928739/yuhdpbgsunky4mrphza0.jpg"
# ]

# ###### Create Loans
# 15.times do
#   Puzzle.create(
#     user_id: User.pluck(:id).sample,
#     title: Faker::Lorem.words(number: 3).join(' '),
#     description: Faker::Lorem.sentence,
#     total_pieces: total_pieces_options.sample,
#     notes: Faker::Lorem.paragraph,
#     puzzle_image_url: puzzle_urls.sample,
#   )
# end

####### Create loans
# loan_status_options = [0, 1, 2, 3]

# 10.times do
#   owner = User.order("RANDOM()").first # Select a random owner
#   borrower = User.order("RANDOM()").first # Select a random borrower
#   puzzle = owner.puzzles.sample # Select a puzzle owned by the owner

#   Loan.create(
#     owner_id: owner.id,
#     borrower_id: borrower.id,
#     puzzle_id: puzzle.id,
#     status: loan_status_options.sample
#   )
# end

###### Users
user1 = User.create(
  full_name: "Diana Puzzler",
  password: "PuzzleQueen1",
  password_confirmation: "PuzzleQueen1",
  email: "dpuzzler@my-email.com",
  zip_code: 12345,
  phone_number: "(101) 111-0000"
)
user2 = User.create(
  full_name: "Hacer Puzzler",
  password: "PuzzleQueen2",
  password_confirmation: "PuzzleQueen2",
  email: "hpuzzler@my-email.com",
  zip_code: 10101,
  phone_number: "(101) 222-0000"
)
user3 = User.create(
  full_name: "Javiera Puzzler",
  password: "PuzzleQueen3",
  password_confirmation: "PuzzleQueen3",
  email: "jpuzzler@my-email.com",
  zip_code: 12345,
  phone_number: "(303) 333-0000"
)
user4 = User.create(
  full_name: "Abebe Puzzler",
  password: "PuzzleQueen4",
  password_confirmation: "PuzzleQueen4",
  email: "apuzzler@my-email.com",
  zip_code: 12345,
  phone_number: "(404) 444-0000"
)
user5 = User.create(
  full_name: "Ida Puzzler",
  password: "PuzzleQueen5",
  password_confirmation: "PuzzleQueen5",
  email: "ipuzzler@my-email.com",
  zip_code: 10101,
  phone_number: "(505) 555-0000"
)

###### Users
puz1 = Puzzle.create(
  user_id: user1.id,
  title: "Flowers",
  description: "flower power",
  total_pieces: 1000,
  notes: "so much fun",
  puzzle_image_url: "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697928739/yuhdpbgsunky4mrphza0.jpg"
)
puz2 = Puzzle.create(
  user_id: user1.id,
  title: "Horses",
  description: "run wild",
  total_pieces: 1000,
  notes: "difficult",
  puzzle_image_url: "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953702/Wild_Beauty_mwbteq.jpg"
)
puz3 = Puzzle.create(
  user_id: user2.id,
  title: "Books",
  description: "readers & books",
  total_pieces: 500,
  notes: "fun and easy",
  puzzle_image_url: "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953701/Readers_Paradise_yzuufl.jpg"
)
puz4 = Puzzle.create(
  user_id: user2.id,
  title: "Farm",
  description: "like on a farm",
  total_pieces: 2000,
  notes: "quick",
  puzzle_image_url: "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953697/Country_Farm_Life_upjwn7.jpg"
)
puz5 = Puzzle.create(
  user_id: user3.id,
  title: "More Flowers",
  description: "flowers in vase",
  total_pieces: 1000,
  notes: "love the colors",
  puzzle_image_url: "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953701/The_Arrangement_by_Erin_Wert_xs8dae.jpg"
)
puz6 = Puzzle.create(
  user_id: user3.id,
  title: "Night Party Farm",
  description: "night party farm",
  total_pieces: 1500,
  notes: "difficult but worth it",
  puzzle_image_url: "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953697/Harvest_Moon_Ball_nfmlff.jpg"
)
puz7 = Puzzle.create(
  user_id: user4.id,
  title: "Winter",
  description: "winter scene",
  total_pieces: 1000,
  notes: "brrr stay warm!",
  puzzle_image_url: "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953696/Friends_in_Winter_idgv3a.jpg"
)
puz8 = Puzzle.create(
  user_id: user4.id,
  title: "Flowers",
  description: "lots of flowers",
  total_pieces: 1000,
  notes: "so many colors!",
  puzzle_image_url: "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953699/Perennials_ly33vr.jpg"
)
puz9 = Puzzle.create(
  user_id: user5.id,
  title: "Sherlock Holmes",
  description: "sherlock holmes scene",
  total_pieces: 1000,
  notes: "feel like a detective",
  puzzle_image_url: "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953699/Sherlock_Holmes_xmi91o.jpg"
)
puz10 = Puzzle.create(
  user_id: user5.id,
  title: "Trailer",
  description: "green trailer",
  total_pieces: 1500,
  notes: "I wanna go on a road trip!",
  puzzle_image_url: "https://res.cloudinary.com/dwcorjdyo/image/upload/v1697953702/Trailerama_rep7ob.jpg"
)

###### Loans
Loan.create(
  owner: user1,
  borrower: user2,
  puzzle: puz1,
  status: 0
)
Loan.create(
  owner: user1,
  borrower: user3,
  puzzle: puz2,
  status: 1
)
Loan.create(
  owner: user1,
  borrower: user5,
  puzzle: puz2,
  status: 3
)
Loan.create(
  owner: user2,
  borrower: user3,
  puzzle: puz3,
  status: 0
)
Loan.create(
  owner: user2,
  borrower: user4,
  puzzle: puz4,
  status: 2
)
Loan.create(
  owner: user3,
  borrower: user1,
  puzzle: puz5,
  status: 1
)
Loan.create(
  owner: user3,
  borrower: user4,
  puzzle: puz6,
  status: 1
)
Loan.create(
  owner: user4,
  borrower: user5,
  puzzle: puz7,
  status: 0
)
Loan.create(
  owner: user4,
  borrower: user1,
  puzzle: puz8,
  status: 2
)
Loan.create(
  owner: user5,
  borrower: user1,
  puzzle: puz9,
  status: 0
)
Loan.create(
  owner: user5,
  borrower: user1,
  puzzle: puz10,
  status: 1
)