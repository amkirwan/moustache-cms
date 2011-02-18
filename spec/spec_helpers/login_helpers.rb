module LoginHelpers
  def login_helper(partners_uid, role)
    cas_faker(partners_uid)  
    create_user(partners_uid, role)
  end
  
  def create_user(partners_uid, role)
    User.create!(:username => partners_uid,
                  :email => "#{partners_uid}@example.com",
                  :role => role)
  end
  
  def cas_faker(partners_uid)
    CASClient::Frameworks::Rails::Filter.fake(partners_uid)
  end
  
  def stub_current_user(user)
    controller.stub(:current_user).and_return(user)
  end 
  
  def logged_in(role)
    @logged_in = mock_model(User, :role? => role[:role?]).as_null_object
    stub_current_user(@logged_in)  
  end             
end