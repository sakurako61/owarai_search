# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
unless Rails.env.production?
  10.times do
    User.create!(name: Faker::Name.name,
                email: Faker::Internet.unique.email,
                password: "password",
                password_confirmation: "password")
  end
end

places = [
  { name: "なんばグランド花月", address: "大阪府大阪市中央区難波千日前11-6", post_code: "542-0075" },
  { name: "ABCホール", address: "大阪府大阪市福島区福島1-1-30", post_code: "553-0003" },
  { name: "よしもと漫才劇場", address: "大阪府大阪市中央区難波千日前12-7", post_code: "542-0075" },
  { name: "新宿ルミネtheよしもと", address: "東京都新宿区新宿3-38-2", post_code: "160-0022" },
  { name: "有楽町よみうりホール", address: "東京都千代田区有楽町1-11-1", post_code: "100-0006" }
]
places.each { |p| Place.find_or_create_by!(name: p[:name]) { |pl| pl.assign_attributes(p) } }

unless Rails.env.production?
  user_ids = User.ids
  place_ids = Place.ids

  20.times do |index|
    open_date = Faker::Time.between(from: 1.month.from_now, to: 6.months.from_now)
    start_date = open_date + 30.minutes
    end_date = start_date + 2.hours
    ticket_start_date = open_date - 1.month
    ticket_end_date = open_date - 1.day

    User.find(user_ids.sample).posts.create!(
      live_name: "#{Faker::Name.name}のお笑いライブ Vol.#{index + 1}",
      description: Faker::Lorem.paragraph(sentence_count: 3),
      open_date: open_date,
      start_date: start_date,
      end_date: end_date,
      ticket_start_date: ticket_start_date,
      ticket_end_date: ticket_end_date,
      price: [ 500, 1000, 1500, 2000, 3000 ].sample,
      live_url: "https://example.com/live/#{index + 1}",
      place_id: place_ids.sample
    )
  end
end
