# user form spec
require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')  

describe "admin/users/_form.html.haml" do
  include FormHelpers
  
  def do_render(label)
    render "admin/users/form", :user => user, :button_label => label
  end
  
  let(:user) { stub_model(User)}
  let(:current_user) { stub_model(User, :role? => true) }
  
  before(:each) do
    assign(:user, user)  
    assign(:current_user, current_user)
  end
  
  it "should render a shared error partial" do
    do_render("label")   
    view.should render_template(:partial => "shared/error_messages", :locals => { :target => user })
  end
  
  context "when the user is a new record" do
    before(:each) do 
      user.as_new_record
    end    
    
    it "should render a form to create a new user" do
      do_render("Create User") 
      form_new(:action => admin_users_path) do |f|
        f.should have_selector("input", :type => "submit", :value => "Create User")   
      end
    end 
    
    it "should show a field to enter the partners username" do
      do_render("Create User")
      form_new(:action => admin_users_path) do |f|
        f.should have_selector("input", :type => "text", :name => "user[puid]")
      end
    end                                                                             

    it "should show a field to enter the username" do
      do_render("Create User")
      form_new(:action => admin_users_path) do |f|
        f.should have_selector("input", :type => "text", :name => "user[username]")
      end
    end   
    
    it "should show a field to enter a firstname" do
      do_render("Create User")
      form_new(:action => admin_users_path) do |f|
        f.should have_selector("input", :type => "text", :name => "user[firstname]")
      end 
    end 
    
    it "should show a field to enter a lastname" do
      do_render("Create User")
      form_new(:action => admin_users_path) do |f|
        f.should have_selector("input", :type => "text", :name => "user[lastname]")
      end 
    end                                      

    it "should show a field to enter an email address" do
      do_render("Create User") 
      form_new(:action => admin_users_path) do |f|
        f.should have_selector("input", :type => "email", :name => "user[email]")
      end
    end

    it "should show radio button to set user role" do
      do_render("Create User")
      form_new(:action => admin_users_path) do |f|
        f.should have_selector("input", :type => "radio", :name => "user[role]", :value => "editor")
        f.should have_selector("input", :type => "radio", :name => "user[role]", :value => "admin")   
      end
    end  
    
    it "should show a cancel link" do
      do_render("Create User")
      form_new(:action => admin_users_path) do |f|
        f.should have_selector("a.cancel", :href => admin_users_path)
      end
    end
  end 
  
  context "when editing an existing user record" do
    
    before(:each) do
      user.stub(:new_record? => false)
    end 
    
    it "should render a form to edit a user account" do
      do_render("Update User")
      form_update(:action => admin_user_path(user)) do |f|
        f.should have_selector("input", :type => "submit", :value => "Update User")   
      end
    end
    
    it "should not have field to update Partners UID" do
      do_render("Update User")
      form_update(:action => admin_user_path(user)) do |f|
        f.should_not have_selector("input", :type => "text", :name => "user[puid]")
      end
    end 
    
    it "should show a field to update the username" do      
      user.stub(:username => "foobar")   
      do_render("Update User")
      form_update(:action => admin_user_path(user)) do |f|
        f.should have_selector("input", :type => "text", :name => "user[username]", :value => "#{user.username}")
      end
    end      
    
    it "should show a field to update the firstname" do
      user.stub(:firstname => "foobar")
      do_render("Update User")
      form_update(:action => admin_user_path(user)) do |f|
        f.should have_selector("input", :type => "text", :name => "user[firstname]", :value => "#{user.firstname}")
      end 
    end 
    
    it "should show a field to enter a lastname" do
      user.stub(:lastname => "foobar")
      do_render("Update User")
      form_new(:action => admin_user_path(user)) do |f|
        f.should have_selector("input", :type => "text", :name => "user[lastname]", :value => "#{user.lastname}")
      end  
    end                                    

    it "should show a field to enter an email address" do  
      user.stub(:email => "foobar@example.com")
      do_render("Update User")
      form_update(:action => admin_user_path(user)) do |f|
        f.should have_selector("input", :type => "email", :name => "user[email]", :value => "#{user.email}")
      end
    end

    it "should show radio button to set user role if user is an admin" do 
      user.stub(:role => "admin")
      do_render("Update User")
      form_update(:action => admin_user_path(user)) do |f|
        f.should have_selector("input", :type => "radio", :name => "user[role]", :value => "editor")
        f.should have_selector("input", :type => "radio", :name => "user[role]", :checked => "checked", :value => "admin")   
      end
    end
    
    it "should not show the radio buttons if the user is not an admin" do 
      current_user.stub(:role? => false)
      do_render("Update User")
      form_update(:action => admin_user_path(user)) do |f|
        f.should_not have_selector("input", :type => "radio", :name => "user[role]", :value => "editor")
        f.should_not have_selector("input", :type => "radio", :name => "user[role]", :value => "admin")   
      end
    end
    
    it "should show a cancel link" do
      do_render("Update User")
      form_update(:action => admin_user_path(user)) do |f|
        f.should have_selector("a.cancel", :href => admin_users_path)
      end
    end
  end
end