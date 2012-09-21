module LoginHelpers  

  def stub_current_admin_user(user)
    User.stub(:where).and_return(users = [user])
    users.stub(:first).and_return(user)
  end 
  
  def stub_current_site(site)
    Site.stub(:match_domain).and_return(sites = [site])
    sites.stub(:first).and_return(site)
  end
  
  def stub_c_site_c_user(site, current_admin_user)
    stub_current_site(site)
    stub_current_admin_user(current_admin_user)
  end
  
  def logged_in(opts)
    current_admin_user = mock_model(User, :username => "foobar", :role? => opts[:role?], :site_id => opts[:site_id])
  end             

  def login_editor
    @current_site = @site = mock_model(Site, :id => "1").as_null_object
    @current_admin_user = @editor_user = FactoryGirl.create(:editor, :site_id => @site.id)
    #controller.stub(:current_site).and_return(@site)
    stub_current_site(@site)
    sign_in @editor_user
    @editor_user
  end

  def login_designer
    @current_site = @site = mock_model(Site, :id => "1").as_null_object
    @current_admin_user = @designer_user = FactoryGirl.create(:designer, :site_id => @site.id)
    #controller.stub(:current_site).and_return(@site)
    stub_current_site(@site)
    sign_in @designer_user
    @designer_user
  end

  def login_admin
    @current_site = @site = mock_model(Site, :id => "1").as_null_object
    @current_admin_user = @admin_user = FactoryGirl.create(:admin, :site_id => @site.id)
    #controller.stub(:current_site).and_return(@site)
    stub_current_site(@site)
    sign_in @admin_user
    @admin_user
  end

end
