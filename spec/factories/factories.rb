Factory.define :site do |site|
  site.sequence(:name) { |n| "name_#{n}" }
  site.sequence(:subdomain)  { |n| "foobar_#{n}" }
  site.default_domain  "example.com" 
  site.domains  { [] }
end

Factory.define :user do |user|
  user.sequence(:puid) { |n| "foobar_#{n}"}
  user.firstname "foobar" 
  user.lastname  "baz" 
  user.sequence(:email) { |n| "foobar_#{n}@example.com" }
  user.role "admin" 
  user.site { Factory.build(:site) }
end

Factory.define :admin, :parent => :user do |admin|
  admin.role "admin" 
end

Factory.define :designer, :parent => :user do |designer|
  designer.role "designer"
end

Factory.define :editor, :parent => :user do |editor|
  editor.role "editor"
end

Factory.define :filter do |filter|
  filter.name "filter"
end

Factory.define :layout do |layout|
  layout.site { Factory.build(:site) }
  layout.sequence(:name) { |n| "layout_#{n}" }
  layout.content "Hello, World!"
  layout.created_by Factory.build(:user)
  layout.updated_by Factory.build(:user) 
end

Factory.define :current_state do |cs|
  cs.name "published"
  cs.time DateTime.new
end       

Factory.define :snippet do |s|  
  s.site { Factory.build(:site) }
  s.sequence(:name) { |n| "name_#{n}" }
  s.content "snippet content"
  s.filter_name "snippet filter"
  s.created_by Factory.build(:user)
  s.updated_by Factory.build(:user)                            
end

Factory.define :page_type do |page_type|
  page_type.name "page_type"
end

Factory.define :page_part do |pp|
  pp.sequence(:name) { |n| "page_part_#{n}" }
  pp.content "Page Part Hello, World!"
  pp.filter_name "filter"
end

Factory.define :page do |page|
  page.site { Factory.build(:site) }
  page.parent 
  page.sequence(:name) { |n| "name_#{n}" }
  page.sequence(:title) { |n| "title_#{n}" }
  page.sequence(:slug) { |n| "slug_#{n}" }
  page.sequence(:full_path) { |n| "/full_path_#{n}" }
  page.sequence(:breadcrumb) { |n| "breadcrumb_#{n}" }
  page.layout { Factory.build(:layout) }
  page.current_state { Factory.build(:current_state) }
  page.editors {[ Factory.build(:user) ]}
  page.post_container false
  page.tags "page"
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

Factory.define :asset_collection do |collection|
  collection.sequence(:name) { |n| "name_#{n}" }
end

Factory.define :site_asset do |asset|
  asset.name "asset_name"
  asset.content_type "content_type"
  asset.asset { File.open("#{Rails.root}/spec/fixtures/assets/rails.png") }
  asset.width 200
  asset.height 200
  asset.file_size 200
end

Factory.define :theme_asset do |asset| 
  asset.name "asset_name"
  asset.content_type "content_type"
  asset.asset { File.open("#{Rails.root}/spec/fixtures/assets/rails.png") }
  asset.width 200
  asset.height 200
  asset.file_size 200
  asset.created_by { Factory.build(:user) }
  asset.updated_by { Factory.build(:user) }
end
