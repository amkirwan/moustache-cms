Given /^these authors exists in the site "([^"]*)"$/ do |site, table|
  site = Site.match_domain(site).first
  table.hashes.each do |hash|
    Factory(:author, :firstname => hash[:firstname], :middlename => hash[:middlename], :lastname => hash[:lastname], :profile => hash[:profile], :site => site)
  end
end

When /^I view the authors page$/ do
  visit admin_authors_path
end

When /^I create a new author$/ do
  fill_in "Firstname", :with => "Anthony"
  fill_in "Middlename", :with => "M"
  fill_in "Lastname", :with => "Kirwan" 
  attach_file('Author Photo', 'spec/fixtures/assets/rails.png')
  fill_in "Profile", :with => "This is Anthony Kirwan's profile"
  click_on "Create Author"
end

When /^I edit the author "([^"]*)" and change the name to "([^"]*)"$/ do |old_author_name, new_author_name|
  click_on old_author_name
  first, last = new_author_name.split(' ')
  fill_in "Firstname", :with => first
  fill_in "Middlename", :with => ""
  fill_in "Lastname", :with => last
  fill_in "Profile", :with => "This is now #{first} #{last} profile"
  click_on "Update Author"
end

When /^I delete the author "([^"]*)"$/ do |author_name|
  click_on author_name
  click_on "Delete Author"
end

When /^I view the author "([^"]*)"$/ do |author_name|
  first, middle, last = author_name.split(' ')
  visit admin_author_path(Author.where(:lastname => last).first.id)
end


Then /^I should see the authors$/ do |table|
  table.hashes.each do |hash|
    page.should have_content hash[:full_name] 
  end
end

Then /^I should see the author "([^"]*)"$/ do |author|
    page.should have_content author
end


Then /^the author "([^"]*)" should not be in the list of authors$/ do |author_name|
  page.should have_content "Successfully deleted the user #{author_name}"
  page.should_not have_link author_name
end

Then /^I should see the "([^"]*)" profile$/ do |author_name|
  first, middle, last = author_name.split(' ')
  author = Author.where(:lastname => last).first
  page.should have_content author.firstname
  page.should have_content author.middlename
  page.should have_content author.lastname
  page.should have_content author.profile
end
