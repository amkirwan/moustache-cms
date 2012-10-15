def set_meta_tags(type)
    [ 
      FactoryGirl.build(:meta_tag, name: 'title', content: "title #{type}"),
      FactoryGirl.build(:meta_tag, name: 'keywords', content: "keywords #{type}"),
      FactoryGirl.build(:meta_tag, name: 'description', content: "description #{type}")
    ]
end

def assign_created_updated_by(obj, relation)
  user = FactoryGirl.create(:user, site_id: obj.site_id)
  obj.created_by = user
  obj.updated_by = user
  user.send(relation.to_s + '_created') << obj
  user.send(relation.to_s + '_updated') << obj
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
  end

  factory :user do
    sequence(:username) { |n| "foo_#{n}"}
    firstname "foo" 
    lastname  "moustache" 
    sequence(:email) { |n| "foo_#{n}@example.com" }
    role "admin" 
    site 
    password "foobar7"
    time_zone "Eastern Time (US & Canada)"
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
    association :site, strategy: :build
    sequence(:name) { |n| "layout_#{n}" }
    content "Hello, World!"
    after(:build) { |layout| assign_created_updated_by(layout, :layouts) }
  end

  factory :current_state do
    name "published"
    time Time.new
  end

  factory :snippet do 
    association :site, strategy: :build
    sequence(:name) { |n| "name_#{n}" }
    content "snippet content"
    filter_name "snippet filter"
    after(:build) { |snippet| assign_created_updated_by(snippet, :snippets) }
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
    association :site, strategy: :build
    sequence(:title) { |n| "title_#{n}" }
    sequence(:slug) { |n| "slug_#{n}" }
    sequence(:breadcrumb) { |n| "breadcrumb_#{n}" }
    tag_list "page"
    meta_tags { set_meta_tags('page') }
    layout { FactoryGirl.build(:layout, site_id: "#{site.id}") }
    current_state { FactoryGirl.build(:current_state) }
    editors { [ FactoryGirl.build(:user, site_id: "#{site.id}") ] }
    page_parts { [ FactoryGirl.build(:page_part) ] }
    after(:build) { |page| assign_created_updated_by(page, :pages) }
  end

  factory :parent_page, :parent => :page do
    parent
    sequence(:title) { |n| "parent_title_#{n}" }
    slug 
    sequence(:full_path) { |n| "parent_full_path_#{n}" }
    sequence(:breadcrumb) { |n| "parent_breadcrumb_#{n}" }
  end     

  factory :author do 
    association :site, strategy: :build
    prefix "prefix"
    firstname "foobar"
    lastname "baz"
    profile "this is the author profile"
    image { File.open("#{Rails.root}/spec/fixtures/assets/rails.png") }
    after(:build) { |author| assign_created_updated_by(author, :authors) }
  end

  factory :moustache_collection do
    association :site, strategy: :build
    sequence(:name) { |n| "name_#{n}" }
  end

  factory :article_collection, parent: :moustache_collection, class: ArticleCollection do 
    editors {[ FactoryGirl.build(:user) ]}
    permalink_prefix false
    after(:build) { |article_collection| assign_created_updated_by(article_collection, :article_collections) }
  end

  factory :article do 
    association :site, strategy: :build
    sequence(:title) { |n| "title_#{n}" }
    subheading 'subheading'  
    sequence(:slug) { |n| "slug_#{n}" }
    tag_list "article"
    layout { FactoryGirl.build(:layout, site_id: "#{site.id}") }
    current_state { FactoryGirl.build(:current_state) }
    meta_tags { set_meta_tags('article') }
    content "article content"
    authors { [FactoryGirl.build(:user, site_id: "#{site.id}")] }
    filter_name "published"
    article_collection { FactoryGirl.build(:article_collection, site_id: "#{site.id}") }
    after(:build) { |article| assign_created_updated_by(article, :articles) }
  end

  factory :moustache_asset do
    name "asset_name"
    content_type "content_type"
    asset { File.open("#{Rails.root}/spec/fixtures/assets/rails.png") }
    width 200
    height 200
    file_size 200
  end

  factory :asset_collection, parent: :moustache_collection, class: AssetCollection do 
    site_assets { [ FactoryGirl.build(:site_asset) ] }
    after(:build) { |asset_collection| assign_created_updated_by(asset_collection, :asset_collections) }
  end

  factory :custom_field do 
    sequence(:name) { |n| "name_#{n}" }
    content "tag attribute value"
  end

  factory :site_asset, class: SiteAsset, parent: :moustache_asset do 
    tag_list "site asset"
  end

  factory :theme_asset, class: ThemeAsset, parent: :moustache_asset do 
  end

  factory :theme_collection, parent: :moustache_collection, class: ThemeCollection  do 
    after(:build) { |theme_collection| assign_created_updated_by(theme_collection, :theme_collections) }
  end
end
