Given /^I am not authenticated$/ do
  visit('/users/sign_out') # ensure that at least
end

Given /^I have one\s+user "([^\"]*)" with email "([^\"]*)" with password "([^\"]*)" and role "([^\"]*)"$/ do |username, email, password, role|
  User.new(:username => username,
           :email => email,
           :role => role,
           :password => password,
           :password_confirmation => password).save!
end 

Given /^I login with email "([^\"]*)" and password "([^\"]*)"$/ do |email, password|
  And %{I go to the admin page}
  And %{I fill in "user_email" with "#{email}"}
  And %{I fill in "user_password" with "#{password}"}
  And %{I press "Sign in"} 
end

Given /^I login as "([^\"]*)" with role "([^\"]*)"$/ do |username, role|
  email = "#{username}@example.com"
  username = username
  password = 'password' 
  role = role

  Given %{I have one user "#{username}" with email "#{email}" with password "#{password}" and role "#{role}"}
  Given %{I login with email "#{email}" and password "#{password}"}
end        

Given /^the user with role$/ do |table|
  table.hashes.each do |hash| 
    Given %{I have one user "#{hash[:user]}" with email "#{hash[:user]}@example.com" with password "#{hash[:user]}" and role "#{hash[:role]}"} 
  end
end
