module LoginHelpers  
  def cas_faker(partners_uid)
    CASClient::Frameworks::Rails::Filter.fake(partners_uid)
  end
  
  def stub_current_user(user)
    controller.stub(:current_user).and_return(user)
  end 
  
  def logged_in(opts)
    current_user = mock_model(User, :puid => "foobar", :role? => opts[:role?], :site => opts[:site]).as_null_object
    stub_current_user(current_user)
    current_user  
  end             
end