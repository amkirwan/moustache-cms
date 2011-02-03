require 'machinist/mongoid'

User.blueprint do
  username  { "user-#{sn}" }
  email  { "person-#{sn}@example.com" }
  password { "abcdefg" }
end