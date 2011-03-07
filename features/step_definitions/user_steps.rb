def find_user(username)
  User.where(:username => username).first
end

When /^(?:|I )edit the account information for the user "([^\"]*)"$/ do |user|
  user = User.where(:username => user).first
  When %{I go to the edit admin user page for "#{user.to_param}"}
end 

Then /^(?:|I )should view the page for user "([^\"]*)"$/ do |username|
  user = find_user(username)
  Then %{I should be on the admin user page for "#{user.to_param}"}
end


Then /^(?:|I )should now be editing the user "([^\"]*)"$/ do |username|
  user = find_user(username)
  Then %{I should be on the edit admin user page for "#{user.to_param}"}
end
