def set_meta_tags(type)
    [ 
      FactoryGirl.build(:meta_tag, name: 'title', content: "title #{type}"),
      FactoryGirl.build(:meta_tag, name: 'keywords', content: "keywords #{type}"),
      FactoryGirl.build(:meta_tag, name: 'description', content: "description #{type}")
    ]
end

FactoryGirl.define do
  factory :meta_tag do 
    name "title"
    content "foobar"
  end

  factory :site do 
    sequence(:name) { |n| "name_#{n}" }
    sequence(:subdomain)  { |n| "foobar_#{n}" }
    meta_tags { set_meta_tags('site') }
    default_domain  "com" 
    domain_names { [] }
  end

  factory :user do 
    sequence(:username) { |n| "foobar_#{n}"}
    firstname "foobar" 
    lastname  "baz" 
    sequence(:email) { |n| "foobar_#{n}@example.com" }
    role "admin" 
    site 
    password "foobar7"
  end

  factory :admin, :parent => :user do 
    role "admin" 
  end

  factory :designer, :parent => :user do
    role "designer"
  end

  factory :editor, :parent => :user do 
    role "editor"
  end

  factory :filter do 
    name "filter"
  end

  factory :layout do 
    site { FactoryGirl.build(:site) }
    sequence(:name) { |n| "layout_#{n}" }
    content "Hello, World!"
    created_by FactoryGirl.build(:user)
    updated_by FactoryGirl.build(:user) 
  end

  factory:current_state do 
    name "published"
    time DateTime.new
  end       

  factory :snippet do 
    site { FactoryGirl.build(:site) }
    sequence(:name) { |n| "name_#{n}" }
    content "snippet content"
    filter_name "snippet filter"
    created_by FactoryGirl.build(:user)
    updated_by FactoryGirl.build(:user)                            
  end

  factory :leaf do 
    site { FactoryGirl.build(:site) }
    sequence(:title) { |n| "title_#{n}" }
    sequence(:slug) { |n| "slug_#{n}" }
    sequence(:breadcrumb) { |n| "breadcrumb_#{n}" }
    layout { FactoryGirl.build(:layout) }
    current_state { FactoryGirl.build(:current_state) }
    tags "leaf"
    meta_tags { set_meta_tags('page') }
    created_by_id { FactoryGirl.build(:user).id }
    updated_by_id { FactoryGirl.build(:user).id }
  end

  factory :page_type do 
    name "page_type"
  end

  factory :page_part do
    sequence(:name) { |n| "page_part_#{n}" }
    content "Page Part Hello, World!"
    filter_name "filter"
  end

  factory :page do 
    site { FactoryGirl.build(:site) }
    sequence(:title) { |n| "title_#{n}" }
    sequence(:slug) { |n| "slug_#{n}" }
    sequence(:breadcrumb) { |n| "breadcrumb_#{n}" }
    layout { FactoryGirl.build(:layout) }
    current_state { FactoryGirl.build(:current_state) }
    editors {[ FactoryGirl.build(:user) ]}
    tags "page"
    meta_tags { set_meta_tags('page') }
    page_parts {[ FactoryGirl.build(:page_part) ]}
    created_by_id { FactoryGirl.build(:user).id }
    updated_by_id { FactoryGirl.build(:user).id }
  end

  factory :parent_page, :parent => :page do
    parent
    sequence(:title) { |n| "parent_title_#{n}" }
    slug 
    sequence(:full_path) { |n| "parent_full_path_#{n}" }
    sequence(:breadcrumb) { |n| "parent_breadcrumb_#{n}" }
    current_state { FactoryGirl.build(:current_state) }
    page_parts {[ FactoryGirl.build(:page_part) ]}
    page_type { FactoryGirl.build(:page_type) }
  end     

  factory :author do 
    site { FactoryGirl.build(:site) }
    prefix "prefix"
    firstname "foobar"
    lastname "baz"
    profile "this is the author profile"
    image { File.open("#{Rails.root}/spec/fixtures/assets/rails.png") }
    created_by_id { FactoryGirl.build(:user).id }
    updated_by_id { FactoryGirl.build(:user).id }
  end

  factory :article_collection do 
    site { FactoryGirl.build(:site) }
    sequence(:name) { |n| "name_#{n}" }
    editors {[ FactoryGirl.build(:user) ]}
    created_by_id { FactoryGirl.build(:user).id }
    updated_by_id { FactoryGirl.build(:user).id }
  end

  factory :article do 
    site { FactoryGirl.build(:site) }
    sequence(:title) { |n| "title_#{n}" }
    sequence(:slug) { |n| "slug_#{n}" }
    tags "article"
    layout_id { FactoryGirl.build(:layout).id }
    current_state { FactoryGirl.build(:current_state) }
    meta_tags { set_meta_tags('article') }
    content "article content"
    author_ids { [FactoryGirl.build(:user).id] }
    filter_name "published"
    article_collection { FactoryGirl.build(:article_collection) }
    created_by_id { FactoryGirl.build(:user).id }
    updated_by_id { FactoryGirl.build(:user).id }
  end

  factory :asset_collection do 
    site { FactoryGirl.build(:site) }
    sequence(:name) { |n| "name_#{n}" }
    site_assets { [ FactoryGirl.build(:site_asset) ] }
    created_by_id { FactoryGirl.build(:user).id }
    updated_by_id { FactoryGirl.build(:user).id }
  end

  factory :site_asset do 
    name "asset_name"
    content_type "content_type"
    asset { File.open("#{Rails.root}/spec/fixtures/assets/rails.png") }
    width 200
    height 200
    file_size 200
  end

  factory :custom_field do 
    sequence(:name) { |n| "name_#{n}" }
    content "tag attribute value"
  end

  factory :theme_asset do 
    name "asset_name"
    content_type "content_type"
    asset { File.open("#{Rails.root}/spec/fixtures/assets/rails.png") }
    width 200
    height 200
    file_size 200
    creator_id { FactoryGirl.build(:user).id }
    updator_id { FactoryGirl.build(:user).id }
  end

  factory :theme_collection do 
    site { FactoryGirl.build(:site) }
    sequence(:name) { |n| "name_#{n}" }
    theme_assets { [] }
    created_by_id { FactoryGirl.build(:user).id }
    updated_by_id { FactoryGirl.build(:user).id }
  end
end
