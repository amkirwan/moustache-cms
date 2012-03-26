def find_user_by_username(username)
  User.where(:site => @site, :username => username).first
end

Given /^I view the list of users with access to the site admin section$/ do
  visit '/admin/users'
end

Given /^these users have admin access$/ do |table|
  table.hashes.each do |hash|
    Factory(:user, :site => @site, :username => hash[:user], :email => "#{hash[:user]}@example.com")
  end
end

When /^I create the user Patrick Kane$/ do
  click_link 'New User'
  fill_in 'Username*', :with => 'pk88'
  fill_in 'Firstname*', :with => 'Patrick'
  fill_in 'Lastname*', :with => 'Kane'
  fill_in 'Email*', :with => 'pkane@example.com'
  fill_in 'Password*', :with => 'foobar7'
  fill_in 'Password Confirmation*', :with => 'foobar7'
  choose 'Admin'
  click_button 'Create User' 
end

When /^I change the fullname to Patrick Kane and username to pk88 of the user foo$/ do
  within 'tr#foo' do
    click_link 'Foobar Baz'
  end
  fill_in 'Username*', :with => 'pk88'
  fill_in 'Firstname*', :with => 'Patrick'
  fill_in 'Lastname*', :with => 'Kane'
  click_button 'Update User' 
end

When /^I change my password to "([^"]*)"$/ do |new_password|
  within 'tr#amkirwan' do
    click_link 'Anthony Kirwan'
  end
  click_link 'Change Password'
  fill_in 'Enter Your Current Password to Confirm Your Changes', :with => 'foobar7'
  fill_in 'New Password', :with => new_password
  fill_in 'Confirm New Password', :with => new_password
  click_button 'Change Password'
end

When /^I edit the user profile "([^"]*)" and delete the user$/ do |username|
  within "tr##{username}" do
    click_link "Foobar Baz"
  end
  click_link "Delete User"
end

When /^I delete the user "([^"]*)" from sites list of users$/ do |username|
  within "tr##{username}" do
    click_link 'Delete'
  end
  dialog_ok
end

Then /^the user Patrick Kane should be on the list of users with access to the sites admin section$/ do
  within 'tr#pk88' do
    page.should have_content('Patrick Kane') # fullname
    page.should have_content('pk88') # usename
    page.should have_content('Admin')
  end
end

Then /^I should see the users listed$/ do
  @site.users.each do |user|
    page.should have_content(user.firstname.capitalize + ' ' + user.lastname.capitalize) 
    page.should have_content(user.username)  
    page.should have_content(user.role.capitalize)
  end
end

Then /^the user should be removed from the users list$/ do
  page.should_not have_content('foo')  
end
