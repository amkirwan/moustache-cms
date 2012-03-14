Given /^the site "([^\"]*)" exists with the domain "([^\"]*)"$/ do |site, domain|
  Factory(:site, :name => site, :subdomain => site, :default_domain => domain)
  #Capybara.app_host = "http://#{site}.#{domain}"
  Capybara.default_host = "http://#{site}.#{domain}"
end

Given /^the user "([^\"]*)" exists with the role of "([^\"]*)" in the site "([^\"]*)"$/ do |username, role, site| 
  user = Factory(:user, :username => username,
                 :firstname => "Anthony",
                 :lastname => "Kirwan",
                 :email => "#{username}@example.com",
                 :role => role,
                 :password => 'foobar7',
                 :site => Site.match_domain(site).first)
end

Given /^I login as the user "([^\"]*)" to the site "([^\"]*)"$/ do |username, site|
  site = Site.match_domain(site).first
  user = User.where(:username => username, :site_id => site.id).first
  Given %{I am not authenticated}
  visit '/admin/sign_in'
  fill_in 'admin_user_email', :with => user.email
  fill_in 'admin_user_password', :with => 'foobar7'
  click_button 'Sign In'
end

Given /^I go to the admin login page$/ do
  visit '/admin/sign_in'
end

When /^I login as an admin$/ do
  @user = User.first(:conditions => {:email => "amkirwan@example.com"})
  fill_in 'Email', :with => @user.email
  fill_in 'Password', :with => 'foobar7'
  click_button 'Sign In'
end

Then /^I should see "(.*)"$/ do |message|
  page.should have_content message
end

