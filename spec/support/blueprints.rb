require 'machinist/mongoid' 

User.blueprint do
  puid { "user_#{sn}" }
  username { "#{object.puid}"}
  email { "#{object.puid}@example.com" }
  role  { "role_#{sn}" }
end

User.blueprint(:admin) do
  puid { "admin_#{sn}" }
  username { "#{object.puid}"}
  email  { "#{object.puid}@example.com" }
  role { "admin" }
end            


User.blueprint(:editor) do
  puid { "editor_#{sn}" }
  username { "#{object.puid}"}
  email  { "#{object.puid}@example.com" }
  role { "editor" }
end

Layout.blueprint do
  name { "layout_#{sn}" }
  content { "Hello, World!" }
  created_by { User.make }
  updated_by { User.make }
  filter  { Filter.make }
end

Page.blueprint do
  name { "name_#{sn}" }
  title { "title_#{sn}"}
  path_name { "path_name_#{sn}" }
  meta_title { "meta_title_#{sn}" }
  meta_keywords { "meta_keyword_#{sn}" }
  meta_description { "meta_description_#{sn}" }
  created_by { User.make! }
  updated_by { User.make! }
  layout { Layout.make! }
  current_state { CurrentState.make }
  editors { [User.make!] }
end

CurrentState.blueprint do
  name { "name_#{sn}" }
end

PagePart.blueprint do
  name { "page_part_#{sn}" }
  filter
end

Filter.blueprint do
  name { "filter_#{sn}" }
end





