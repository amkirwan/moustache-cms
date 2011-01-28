require 'machinist/mongoid'

Person.blueprint do
  username  { "user-#{sn}" }
  email  { "person-#{sn}@example.com" }
  password { "abcdefg" }
end