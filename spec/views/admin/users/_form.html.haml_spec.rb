require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')  

describe "admin/users/_form.html.haml" do
    
    context "when the user is a new record" do
      before(:each) do 
        @user = assign(:user, stub_model(User).as_new_record) 
        render "form", :user => @user, :button_label => "Create User"
      end 

      it "should render a form to create a new user" do 
        rendered.should have_selector("form", :method => "post", :action => admin_users_path) do |form|
          form.should have_selector("input", :type => "submit", :value => "Create User")   
        end
      end                                                                                   

      it "should show a field to enter the username" do
        rendered.should have_selector("form") do |form|
          form.should have_selector("input", :type => "text", :name => "user[username]")
        end
      end                                          

      it "should show a field to enter an email address" do 
        rendered.should have_selector("form") do |form|
          form.should have_selector("input", :type => "email", :name => "user[email]")
        end
      end

      it "should show radio button to set user role" do
        rendered.should have_selector("form") do |form|
          form.should have_selector("input", :type => "radio", :name => "user[role]", :value => "editor")
          form.should have_selector("input", :type => "radio", :name => "user[role]", :value => "admin")   
        end
      end
    end 
end