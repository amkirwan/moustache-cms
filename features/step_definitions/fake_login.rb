Given /^I authenticates as cas user "([^\"]*)"$/ do |username|
  #CASClient::Frameworks::Rails::Filter.fake(username)  
end 

Given /^I am not authenticated$/ do
  visit '/admin/sign_out'
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


Given /^the user "([^\"]*)" exists with the role of "([^\"]*)" in the site "([^\"]*)"$/ do |username, role, site| 
  user = Factory(:user, :username => username,
                 :email => "#{username}@example.com",
                 :role => role,
                 :site => Site.match_domain(site).first)
end

Given /^the site "([^\"]*)" exists with the domain "([^\"]*)"$/ do |site, domain|
  Factory(:site, :name => site, :subdomain => site, :default_domain => domain)
  #Capybara.app_host = "http://#{site}.#{domain}"
  Capybara.default_host = "http://#{site}.#{domain}"
end

Given /^I login to the site "([^\"]*)" as "([^\"]*)" with the role of "([^\"]*)"$/ do |site, username, role|
  Given %{the user "#{username}" exists with the role of "#{role}" in the site "#{site}"}
  Given %{cas authenticates with cas user "#{username}"}
end   

Given /^the user with the role exist$/ do |table|
  table.hashes.each do |hash|
    Given %{the user "#{hash[:user]}" exists with the role of "#{hash[:role]}" in the site "#{hash[:site]}"}
  end
end 

When /^I want to go to the site "([^\"]*)"$/ do |site|
 Capybara.default_host = "#{site}.example.com"
end
