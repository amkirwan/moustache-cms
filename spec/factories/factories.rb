Factory.define :user do |user|
  user.sequence(:puid) { |n| "foobar_#{n}"}
  user.firstname "foobar" 
  user.lastname  "baz" 
  user.sequence(:email) { |n| "foobar_#{n}@example.com" }
  user.role "admin" 
end

Factory.define :admin, :parent => :user do |admin|
  admin.role "admin" 
end

Factory.define :editor, :parent => :user do |editor|
  editor.role "editor"
end

Factory.define :meta_data do |meta|

end

Factory.define :filter do |filter|
  filter.name "filter"
end

Factory.define :site do |site|
  site.sequence(:name) { |n| "name_#{n}" }
  site.sequence(:subdomain)  { |n| "foobar_#{n}" }
  site.default_domain  "example.com" 
  site.domains  { [] }
  site.meta_keywords "meta_keywords"
  site.meta_description "meta_description"
end

Factory.define :layout do |layout|
  layout.site { Factory(:site) }
  layout.sequence(:name) { |n| "layout_#{n}" }
  layout.content "Hello, World!"
  layout.created_by Factory.build(:user)
  layout.updated_by Factory.build(:user) 
end

Factory.define :current_state do |cs|
  cs.name "published"
  cs.time DateTime.new
end

Factory.define :page_type do |page_type|
  page_type.name "page_type"
end

Factory.define :page_part do |pp|
  pp.sequence(:name) { |n| "page_part_#{n}" }
  pp.content "Page Part Hello, World!"
  pp.filter { Factory.build(:filter) }
end

Factory.define :page do |page|
  page.site { Factory.build(:site) }
  page.parent 
  page.sequence(:title) { |n| "title_#{n}" }
  page.sequence(:slug) { |n| "slug_#{n}" }
  page.sequence(:full_path) { |n| "full_path_#{n}" }
  page.sequence(:breadcrumb) { |n| "breadcrumb_#{n}" }
  page.meta_data { Factory.build(:meta_data) }
  page.layout { Factory.build(:layout) }
  page.current_state { Factory.build(:current_state) }
  page.editors {[ Factory.build(:user) ]}
  page.tags 
  page.page_parts {[ Factory.build(:page_part) ]}
  page.created_by { Factory.build(:user) }
  page.updated_by { Factory.build(:user) }
end

Factory.define :parent_page, :parent => :page do |pp|
  pp.parent
  pp.sequence(:title) { |n| "parent_title_#{n}" }
  pp.slug 
  pp.sequence(:full_path) { |n| "parent_full_path_#{n}" }
  pp.sequence(:breadcrumb) { |n| "parent_breadcrumb_#{n}" }
  pp.current_state { Factory.build(:current_state) }
  pp.page_parts {[ Factory.build(:page_part) ]}
  pp.page_type { Factory.build(:page_type) }
end