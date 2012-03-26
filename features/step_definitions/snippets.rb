def find_snippet_by_name(name)
  Snippet.where(:site => @site, :name => name).first
end

Given /^I view the snippets in the site$/ do
  visit '/admin/snippets'
end

Given /^these snippets exist$/ do |table|
  table.hashes.each do |hash|
    create_snippet(hash[:name])
  end
end

Given /^I want to create a new snippet in the site$/ do
  step %{I view the snippets in the site}
  click_link 'New Snippet'
end

When /^I create a snippet with the name "([^"]*)"$/ do |name|
  fill_in 'Name', :with => name
  select 'markdown', :from => "Filter name"
  fill_in 'Content', :with => "hello, world"
  click_button 'Create Snippet'
end

When /^I change the snippet name to "([^"]*)"$/ do |snippet_name|
  click_link 'foobar'
  fill_in 'Name', :with => snippet_name
  click_button 'Update Snippet'
end

When /^I edit the snippet "([^"]*)" and delete it$/ do |snippet_name|
  click_link snippet_name
  click_link 'Delete Snippet'
end


When /^I delete the snippet "([^"]*)" from the snippets list$/ do |snippet_name|
  within "tr#snippet_#{snippet_name}" do
    click_link 'Delete'
  end
  dialog_ok
  wait_for_ajax
end

Then /^I should see the snippets listed$/ do
  @site.snippets.each do |snippet|
    step %{I should see "#{snippet.name}" in the snippets list}
  end
end

Then /^I should see "([^"]*)" in the snippets list$/ do |snippet_name|
  page.should have_content snippet_name
end 


Then /^the snippet should be removed from the snippets list$/ do
  page.should_not have_selector('tr#snippet_foobar')
end
