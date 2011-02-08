Given /^cas authenticates with cas user "([^\"]*)"$/ do |username|
  CASClient::Frameworks::Rails::Filter.fake(username)
end

Given /^I login as "([^\"]*)" with the role of "([^\"]*)"$/ do |username, role|
  @user = User.new(:username => username,
           :email => "#{username}@example.com",
           :role => role).save!
  Given %{cas authenticates with cas user "#{username}"}
end