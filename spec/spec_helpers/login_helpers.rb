module LoginHelpers  
  def cas_faker(partners_uid)
    CASClient::Frameworks::Rails::Filter.fake(partners_uid)
  end
  
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
end