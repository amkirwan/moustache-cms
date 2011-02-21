Given /^cas authenticates with cas user "([^\"]*)"$/ do |username|
  CASClient::Frameworks::Rails::Filter.fake(username)  
end 

Given /^the user "([^\"]*)" exists with the role of "([^\"]*)"$/ do |username, role| 
  User.create!(:username => username,
               :email => "#{username}@example.com",
               :role => role)
end

Given /^I login as "([^\"]*)" with the role of "([^\"]*)"$/ do |username, role|
  Given %{the user "#{username}" exists with the role of "#{role}"}
  Given %{cas authenticates with cas user "#{username}"}
end   

Given /^the user with the role exist$/ do |table|
  table.hashes.each do |hash|
    Given %{the user "#{hash[:user]}" exists with the role of "#{hash[:role]}"}
  end
end 

Then /^(?:|I )should now be editing the user "([^\"]*)"$/ do |user|
  user = User.where(:username => user).first
  Then %{I should be on the edit admin user page for "#{user.to_param}"}
end