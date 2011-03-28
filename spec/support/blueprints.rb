require 'machinist/mongoid' 

User.blueprint do
  puid { "user_#{sn}" }
  #username { "user_#{sn}" }
  firstname { "firstname_#{object.puid}"}
  lastname { "lastname_#{object.puid}"}
  email { "#{object.puid}@example.com" }
  role  { "role_#{sn}" }
end

User.blueprint(:admin) do
  puid { "admin_#{sn}" }
  firstname { "firstname_#{object.puid}"}
  lastname { "lastname_#{object.puid}"}
  email  { "#{object.puid}@example.com" }
  role { "admin" }
end            

User.blueprint(:editor) do
  puid { "editor_#{sn}" }
  firstname { "firstname_#{object.puid}"}
  lastname { "lastname_#{object.puid}"}
  email  { "#{object.puid}@example.com" }
  role { "editor" }
end

Filter.blueprint do
  name { "filter_#{sn}" }
end

Layout.blueprint do
  name { "layout_#{sn}" }
  content { "Hello, World!" }
  filter  { Filter.make }
  created_by { User.make }
  updated_by { User.make }
end

CurrentState.blueprint do
  name { "name_#{sn}" }
  published_at { DateTime.now }
end

PagePart.blueprint do
  name { "page_part_#{sn}" }
  content { "Hello, World!" }
end

Page.blueprint do
  title { "title_#{sn}"}
  slug { "slug_#{object.title}" }
  full_path { "full_path#{object.full_path}" }
  breadcrumb { "breadcrumb_#{object.title}" }
  meta_title { "meta_title_#{object.title}" }
  meta_keywords { "meta_keyword_#{object.title}" }
  meta_description { "meta_description_#{object.title}" }
  created_by { User.make! }
  updated_by { User.make! }
  layout { Layout.make! }
  current_state { CurrentState.make }
  editors { [ User.make! ] }
  filter { Filter.make! }
  tags { [ "tag"] }
  page_parts { [ PagePart.make(:name => "content") ]}
end