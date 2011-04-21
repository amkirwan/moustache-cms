Given /^cas authenticates with cas user "([^\"]*)"$/ do |username|
  CASClient::Frameworks::Rails::Filter.fake(username)  
end 

Given /^the user "([^\"]*)" exists with the role of "([^\"]*)"$/ do |username, role| 
  Factory(:user, :puid => username,
                 :username => username,
                 :email => "#{username}@example.com",
                 :role => role)
end

Given /^the site "([^\"]*)" exists$/ do |site|
  Factory(:site, :name => "foobar", :subdomain => "foobar" )
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