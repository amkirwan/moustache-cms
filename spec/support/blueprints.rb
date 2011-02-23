require 'machinist/mongoid' 

User.blueprint do
  puid { "user-puid-#{sn}" }
  username { "user-username-#{sn}"}
  email { "user-#{sn}@example.com" }
  role  { "role-#{sn}" }
end

User.blueprint(:admin) do
  puid { "admin-puid-#{sn}" }
  username { "admin-username-#{sn}"}
  email  { "admin-#{sn}@example.com" }
  role { "admin" }
end            


User.blueprint(:editor) do
  puid { "editor-puid-#{sn}" }
  username { "editor-username-#{sn}"}
  email  { "editor-#{sn}@example.com" }
  role { "editor" }
end
