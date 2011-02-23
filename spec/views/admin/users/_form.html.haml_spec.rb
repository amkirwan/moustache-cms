require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')  

describe "admin/users/_form.html.haml" do 
  let(:user) { stub_model(User).as_new_record }
  let(:current_user) { stub_model(User, :role? => true) }
  context "when the user is a new record" do
    before(:each) do 
      assign(:user, user)  
      assign(:current_user, current_user)
    end   
    
    def do_render
      render "form", :user => user, :button_label => "Create User"
    end  
    
    it "should render a form to create a new user" do
      do_render 
      rendered.should have_selector("form", :method => "post", :action => admin_users_path) do |form|
        form.should have_selector("input", :type => "submit", :value => "Create User")   
      end
    end                                                                                

    it "should show a field to enter the username" do
      do_render
      rendered.should have_selector("form") do |form|
        form.should have_selector("input", :type => "text", :name => "user[username]")
      end
    end                                          

    it "should show a field to enter an email address" do
      do_render 
      rendered.should have_selector("form") do |form|
        form.should have_selector("input", :type => "email", :name => "user[email]")
      end
    end

    it "should show radio button to set user role" do
      do_render
      rendered.should have_selector("form") do |form|
        form.should have_selector("input", :type => "radio", :name => "user[role]", :value => "editor")
        form.should have_selector("input", :type => "radio", :name => "user[role]", :value => "admin")   
      end
    end  
    
    it "should show a cancel link" do
      do_render
      rendered.should have_selector("form") do |form|
        form.should have_selector("a.cancel", :href => admin_users_path)
      end
    end
  end 
  
  context "when editing an existing user record" do
    let(:user) { stub_model(User) }
    let(:current_user) { stub_model(User, :role? => true) }
    before(:each) do
      assign(:user, user)  
      assign(:current_user, current_user)
    end 
    
    def do_render
      render "form", :user => user, :button_label => "Update User"
    end
    
    it "should render a form to edit a user account" do
      do_render 
      rendered.should have_selector("form", :method => "post", :action => admin_user_path(user)) do |form|
        form.should have_selector("input", :type => "submit", :value => "Update User")   
      end
    end 
    
    it "should show a field to update the username" do      
      user.stub(:username => "foobar")   
      do_render
      rendered.should have_selector("form") do |form|
        form.should have_selector("input", :type => "text", :name => "user[username]", :value => "#{user.username}")
      end
    end                                          

    it "should show a field to enter an email address" do  
      user.stub(:email => "foobar@example.com")
      do_render 
      rendered.should have_selector("form") do |form|
        form.should have_selector("input", :type => "email", :name => "user[email]", :value => "#{user.email}")
      end
    end

    it "should show radio button to set user role if user is an admin" do 
      user.stub(:role => "admin")
      do_render 
      rendered.should have_selector("form") do |form|
        form.should have_selector("input", :type => "radio", :name => "user[role]", :value => "editor")
        form.should have_selector("input", :type => "radio", :name => "user[role]", :checked => "checked", :value => "admin")   
      end
    end
    
    it "should not show the radio buttons if the user is not an admin" do 
      current_user.stub(:role? => false)
      do_render
      rendered.should have_selector("form") do |form|
        form.should_not have_selector("input", :type => "radio", :name => "user[role]", :value => "editor")
        form.should_not have_selector("input", :type => "radio", :name => "user[role]", :value => "admin")   
      end
    end
    
    it "should show a cancel link" do
      do_render
      rendered.should have_selector("form") do |form|
        form.should have_selector("a.cancel", :href => admin_users_path)
      end
    end
  end
end