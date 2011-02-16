require 'machinist/mongoid'

User.blueprint(:admin) do
  username  { "admin-#{sn}" }
  email  { "admin-#{sn}@example.com" }
  role { "admin" }
end            


User.blueprint(:editor) do
  username  { "editor-#{sn}" }
  email  { "editor-#{sn}@example.com" }
  role { "editor" }
end
