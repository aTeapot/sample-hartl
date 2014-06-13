namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_microposts
    make_subscriptions
  end
end

def make_users
  admin = User.create!(name:     "Example User",
                       email:    "example@railstutorial.org",
                       password: "foobar",
                       password_confirmation: "foobar",
                       admin: true)
  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password = "password"
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_microposts
  User.limit(6).each do |user|
    50.times do
      content = Faker::Lorem.sentence(5)
      user.microposts.create!(content: content)
    end
  end
end

def make_subscriptions
  users = User.all
  users.each do |follower|
    users.sample(rand(30)).each do |author|  # follow a few authors
      follower.follow!(author) unless follower == author
    end
  end
end
