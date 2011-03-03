require 'machinist/mongoid' 

User.blueprint do
  puid { "user_#{sn}" }
  username { "#{object.puid}_#{sn}"}
  email { "#{object.puid}@example.com" }
  role  { "role_#{sn}" }
end

User.blueprint(:admin) do
  puid { "admin_#{sn}" }
  username { "#{object.puid}_#{sn}"}
  email  { "#{object.puid}@example.com" }
  role { "admin" }
end            


User.blueprint(:editor) do
  puid { "editor_#{sn}" }
  username { "#{object.puid}_#{sn}"}
  email  { "#{object.puid}@example.com" }
  role { "editor" }
end

Layout.blueprint do
  name { "layout_#{sn}" }
  content { "Hello, World!" }
  created_by { User.make }
  updated_by { User.make }
end

TextFilter.blueprint do
  name { "text_filter_#{sn}" }
end

