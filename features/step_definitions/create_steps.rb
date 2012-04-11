module Create

  def create_site(site='foobar', domain='example.com')
    @site = FactoryGirl.build(:site, :name => site, :subdomain => site, :default_domain => domain)
    @site.add_domain '127.0.0.1'
    @site.save
  end

  def create_user(hash)
    @user = FactoryGirl.create(:user, :site => @site, :username => hash[:user], :email => "#{hash[:user]}@example.com", :firstname => hash[:firstname], :lastname => hash[:lastname])
  end

  def create_layout(name='foobar')
    @layout = FactoryGirl.create(:layout, :name => name, :site => @site, :created_by => @user, :updated_by => @user)
  end  

  def create_page(title, status)
    FactoryGirl.create(:page, :site => @site,
                     :parent_id => @parent.id,
                     :layout => @layout,
                     :created_by => @user,
                     :updated_by => @user,
                     :editors => [@user],
                     :title => title,
                     :current_state => FactoryGirl.build(:current_state, :name => status),
                     :page_parts => [FactoryGirl.build(:page_part, :name => 'foobar')])

  end

  def create_child_page(title, status, parent)
    FactoryGirl.create(:page, :site => @site,
                     :parent_id => parent.id,
                     :layout => @layout,
                     :created_by => @user,
                     :updated_by => @user,
                     :editors => [@user],
                     :title => title,
                     :current_state => FactoryGirl.build(:current_state, :name => status),
                     :page_parts => [FactoryGirl.build(:page_part, :name => 'foobar')])

  end

  def create_homepage
    @parent = FactoryGirl.create(:page, :title => 'Homepage', :site => @site, :layout => @layout, :created_by => @user, :updated_by => @user)
  end

  def create_snippet(name)
    @snippet = FactoryGirl.create(:snippet, :name => name, :site => @site)
  end

  def create_article_collection(name)
    @article_collection = FactoryGirl.create(:article_collection, :name => name, :site => @site)
  end

  def create_article(title, article_collection)
    @article = FactoryGirl.create(:article, :article_collection => article_collection, :site => @site, :title => title)
  end

  def create_asset_collection(name)
    @asset_collection = FactoryGirl.create(:asset_collection, :name => name, :site => @site)
  end

  def create_author(props)
    @author = FactoryGirl.create(:author, :firstname => props[:firstname], :lastname => props[:lastname], :site => @site)
  end

  def create_theme_collection(props)
    @theme_collection = FactoryGirl.create(:theme_collection, :name => props[:name], :site => @site)
  end

  def create_theme_asset(props, theme_collection)
    @theme_asset = FactoryGirl.build(:theme_asset, :name => props[:name]) 
    theme_collection.theme_assets << @theme_asset
  end
end

World(Create)
