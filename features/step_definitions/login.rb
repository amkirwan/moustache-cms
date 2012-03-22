def login(email=@user.email, password=@user.password)
  fill_in 'Email', :with => email
  fill_in 'Password', :with => password
  click_button 'Sign In'
end

Given /^the site "([^\"]*)" exists with the domain "([^\"]*)"$/ do |site, domain|
  create_site(site, domain)
  Capybara.default_host = "http://#{site}.#{domain}"
end

Given /^the user "([^\"]*)" exists with the role of "([^\"]*)" in the site "([^\"]*)"$/ do |username, role, site| 
  @user = Factory(:user, :username => username,
                 :firstname => "Anthony",
                 :lastname => "Kirwan",
                 :email => "#{username}@example.com",
                 :role => role,
                 :password => 'foobar7',
                 :site => Site.match_domain(site).first)
end

Given /^I go to the admin login page$/ do
  visit '/admin/sign_in'
end

Given /^I have the site "([^\"]*)" setup$/ do |site|
  steps %{When the site "#{site}" exists with the domain "example.com"}
end

Given /^a homepage and layout for the site have been created$/ do
  create_layout
  create_homepage
end

Given /^I am an authenticated user with the role of "([^\"]*)"$/ do |role|
  steps %{
    Given the user "amkirwan" exists with the role of "#{role}" in the site "foobar.example.com"
    And a homepage and layout for the site have been created
    And I go to the admin login page
    When I login as an admin
  } 
end

When /^I login as an admin$/ do
  login
end

When /^I try to login as a user that does not exist$/ do
  login "foobar@example.com", "blahblah"
end

