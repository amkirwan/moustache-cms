require '../spec_helper'     

describe "renam" do

  it "should go to /admin/login for /devise/sign_in" do
    { :get => "/admin/login" }.should route_to(
      :controller => "devise/sessions",
      :action => "new"
    )
  end 
  
  it "should go to /admin/logout for /devise/sign_out" do
    { :delete => "/admin/logout" }.should route_to(
      :controller => "devise/sessions",
      :action => "destroy"
    )
  end
end