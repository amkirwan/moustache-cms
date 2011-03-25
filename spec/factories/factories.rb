
Factory.define :user do |user|
  user.sequence(:puid) { |n| "foobar_#{n}"}
  user.firstname "foobar" 
  user.lastname  "baz" 
  user.sequence(:email) { |n| "fbaz_#{n}@example.com" }
  user.role "admin" 
end

Factory.define :admin, :parent => :user do |admin|
  admin.role "admin" 
end

Factory.define :editor, :parent => :user do |editor|
  editor.role "editor"
end

Factory.define :filter do |filter|
  filter.name "filter"
end

Factory.define :layout do |layout|
  layout.sequence(:name) { |n| "layout_#{n}" }
  layout.content "Hello, World!"
  layout.filter { Factory.build(:filter) }
  layout.created_by Factory.build(:user)
  layout.updated_by Factory.build(:user)
end

Factory.define :current_state do |cs|
  cs.name "published"
  cs.published_at DateTime.new
end

Factory.define :page_part do |pp|
  pp.sequence(:name) { |n| "page_part_#{n}" }
  pp.content "Hello, World!"
end

Factory.define :page do |page|
  page.sequence(:title) { |n| "title_#{n}" }
  page.sequence(:slug) { |n| "slug_#{n}" }
  page.sequence(:breadcrumb) { |n| "breadcrumb_#{n}" }
  page.meta_title "meta_title"
  page.meta_keywords "meta_keywords"
  page.meta_description "meta_description"
  page.layout_id { Factory.build(:layout).id }
  page.current_state { Factory.build(:current_state) }
  page.editors {[ Factory.build(:user) ]}
  page.filter { Factory.build(:filter) }
  page.tags 
  page.page_parts {[ Factory.build(:page_part) ]}
  page.created_by Factory.build(:user)
  page.updated_by Factory.build(:user)
end
