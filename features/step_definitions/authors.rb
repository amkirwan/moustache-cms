def fill_in_name(firstname, lastname)
  fill_in 'Firstname', :with => firstname
  fill_in 'Lastname', :with => lastname
end

Given /^these authors exist$/ do |table|
  table.hashes.each do |hash|
    create_author(hash)
  end
end

Given /^I want to create a author in the site$/ do
  new_form 'authors', 'New Author'
end

When /^I create a author with the firstname "([^"]*)" and the lastname "([^"]*)"$/ do |firstname, lastname|
  fill_in_name(firstname, lastname)
  attach_file :image, File.join(Rails.root, 'spec', 'fixtures', 'assets', 'columbo.png')
  click_button 'Create Author'
end


When /^I change the author Foobar Handlebar's firstname to "([^"]*)" and the lastname to "([^"]*)"$/ do |firstname, lastname|
  step %{I view the authors in the site}
  click_link 'Foobar Handlebar'
  fill_in_name(firstname, lastname)
  click_button 'Update Author'
end

When /^I edit the author "([^"]*)" and delete it$/ do |author_name|
  delete_within_item author_name, 'Delete Author'
end

When /^I delete the author "([^"]*)" from the authors list$/ do |author_name|
  
  delete_from_index "tr#author_#{author_name.parameterize('_')}"
end

Then /^I should see the authors listed$/ do
  @site.authors.each do |author|
    step %{I should see "#{author.full_name}" in the layouts list}
  end
end
  
Then /^the author should be removed from the authors list$/ do
  removed_item_by_selector 'tr#author_foobar_handlebar'
end
