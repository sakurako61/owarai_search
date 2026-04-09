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

if Rails.env.production? && User.count.zero?
  User.create!(name: "デモユーザー",
              email: "demo@example.com",
              password: "password",
              password_confirmation: "password")
end

places = [
  { name: "なんばグランド花月",         address: "大阪府大阪市中央区難波千日前11-6",          post_code: "542-0075" },
  { name: "よしもと漫才劇場",           address: "大阪府大阪市中央区難波千日前12-7",          post_code: "542-0075" },
  { name: "ルミネtheよしもと",          address: "東京都新宿区新宿3-38-2",                  post_code: "160-0022" },
  { name: "有楽町よみうりホール",        address: "東京都千代田区有楽町1-11-1",               post_code: "100-0006" },
  { name: "渋谷よしもと漫才劇場",        address: "東京都渋谷区宇田川町31-2",                 post_code: "150-0042" },
  { name: "神保町よしもと漫才劇場",      address: "東京都千代田区神田神保町1丁目23 2Fビル",    post_code: "101-0051" },
  { name: "大宮ラクーンよしもと劇場",    address: "埼玉県さいたま市大宮区宮町1丁目60 大宮RAKUUN 6F", post_code: "330-0802" },
  { name: "本多劇場",                  address: "東京都世田谷区北沢2丁目10-15",              post_code: "155-0031" },
  { name: "LINE CUBE SHIBUYA",        address: "東京都渋谷区宇田川町1-1",                  post_code: "150-0042" },
  { name: "浅草公会堂",                address: "東京都台東区浅草1-38-6",                   post_code: "111-0032" }
]
places.each { |p| Place.find_or_create_by!(name: p[:name]) { |pl| pl.assign_attributes(p) } }

# 旧名称「新宿ルミネtheよしもと」を「ルミネtheよしもと」に更新
Place.where(name: "新宿ルミネtheよしもと").update_all(name: "ルミネtheよしもと")
# 不要な「ABCホール」を削除（投稿に紐づいていない場合のみ）
Place.left_joins(:posts).where(name: "ABCホール", posts: { id: nil }).destroy_all

comedian_names = [
  "ミルクボーイ", "霜降り明星", "和牛", "かまいたち", "マヂカルラブリー",
  "ニューヨーク", "見取り図", "おいでやすこが", "錦鯉", "モグライダー",
  "ウエストランド", "さや香", "令和ロマン", "バッテリィズ", "エバース"
]
comedians = comedian_names.map { |name| Comedian.find_or_create_by!(name: name) }

if Post.count.zero?
  user_ids = User.ids
  place_ids = Place.ids

  if Rails.env.production?
    demo_posts = [
      { live_name: "ミルクボーイ単独ライブ2025", description: "大人気コンビによる待望の単独ライブ！" },
      { live_name: "霜降り明星のお笑いの日", description: "M-1王者が贈る爆笑ライブ。" },
      { live_name: "かまいたち漫才SHOW", description: "圧倒的漫才力を披露する豪華公演。" },
      { live_name: "令和ロマン単独公演", description: "若き王者による全力の漫才ライブ。" },
      { live_name: "バッテリィズ旗揚げ公演", description: "新星コンビのお笑いライブ。笑いの嵐をお届け！" }
    ]
    demo_posts.each_with_index do |attrs, index|
      open_date = (index + 1).months.from_now
      post = User.find(user_ids.sample).posts.create!(
        live_name: attrs[:live_name],
        description: attrs[:description],
        open_date: open_date,
        start_date: open_date + 30.minutes,
        end_date: open_date + 2.hours + 30.minutes,
        ticket_start_date: open_date - 1.month,
        ticket_end_date: open_date - 1.day,
        price: [ 1000, 1500, 2000, 3000 ].sample,
        live_url: "https://example.com/live/#{index + 1}",
        place_id: place_ids.sample
      )
      comedians.sample(rand(1..2)).each do |comedian|
        post.performers.create!(comedian: comedian)
      end
    end
  else
    20.times do |index|
      open_date = Faker::Time.between(from: 1.month.from_now, to: 6.months.from_now)
      start_date = open_date + 30.minutes
      end_date = start_date + 2.hours
      ticket_start_date = open_date - 1.month
      ticket_end_date = open_date - 1.day

      post = User.find(user_ids.sample).posts.create!(
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

      comedians.sample(rand(1..3)).each do |comedian|
        post.performers.create!(comedian: comedian)
      end
    end
  end
end
