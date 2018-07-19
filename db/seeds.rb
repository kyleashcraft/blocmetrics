require 'faker'

5.times do
  User.create!(
    email: Faker::Internet.unique.email,
    password: 'password'
  )
end

users = User.all

puts "#{users.count} users created."

10.times do
  name = Faker::App.unique.name
  RegisteredApplication.create!(
    name: name,
    url: Faker::Internet.unique.url("#{name.downcase}.com"),
    user: users.sample
  )
end

apps = RegisteredApplication.all

puts "#{apps.count} applications registered."

200.times do
  Event.create!(
    name: Faker::Color.color_name,
    registered_application: apps.sample,
    created_at: Faker::Date.backward(30)
  )
end

events = Event.all

puts "#{events.count} events created."
