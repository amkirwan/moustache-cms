When /^(?:|I )edit "([^\"]*)" account information$/ do |user|
  user = User.where(:puid => user).first
  When %{I go to the edit admin user page for "#{user.to_param}"}
end 


Then /^(?:|I )should now be editing the user "([^\"]*)"$/ do |user|
  user = User.where(:puid => user).first
  Then %{I should be on the edit admin user page for "#{user.to_param}"}
end
