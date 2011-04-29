def find_user(puid)
  User.where(:puid => puid).first
end

When /^(?:|I )edit the account information for the user "([^\"]*)"$/ do |user|
  user = User.where(:puid => user).first
  When %{I go to the edit admin user page for "#{user.to_param}"}
end 

Then /^(?:|I )should view the page for user "([^\"]*)"$/ do |puid|
  user = find_user(puid)
  Then %{I should be on the admin user page for "#{user.to_param}"}
end


Then /^(?:|I )should now be editing the user "([^\"]*)"$/ do |puid|
  user = find_user(puid)
  Then %{I should be on the edit admin user page for "#{user.to_param}"}
end
