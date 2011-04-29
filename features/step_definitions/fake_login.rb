Given /^cas authenticates with cas user "([^\"]*)"$/ do |puid|
  CASClient::Frameworks::Rails::Filter.fake(puid)  
end 

Given /^the user "([^\"]*)" exists with the role of "([^\"]*)"$/ do |puid, role| 
  Factory(:user, :puid => puid,
                 :puid => puid,
                 :email => "#{puid}@example.com",
                 :role => role)
end

Given /^the site "([^\"]*)" exists$/ do |site|
  Factory(:site, :name => "foobar", :subdomain => "foobar" )
end

Given /^I login as "([^\"]*)" with the role of "([^\"]*)"$/ do |puid, role|
  Given %{the user "#{puid}" exists with the role of "#{role}"}
  Given %{cas authenticates with cas user "#{puid}"}
end   

Given /^the user with the role exist$/ do |table|
  table.hashes.each do |hash|
    Given %{the user "#{hash[:user]}" exists with the role of "#{hash[:role]}"}
  end
end 