Given /^these additional sites exist$/ do |table|
  table.hashes.each do |hash|
    create_site(hash[:name])
  end
end

Given /^I want to create another site$/ do
  step %{I view all the sites}
end

Given /^I view the site settings$/ do
  click_link 'Site Settings'
end

When /^I view all the sites$/ do
  step %{I view the site settings}
  click_link 'Sites'
end

When /^I create a site with the name "([^"]*)"$/ do |site_name|
  click_link 'New Site'
  fill_in 'Name', :with => site_name
  fill_in 'Subdomain', :with => site_name
  fill_in 'Domain', :with => 'org'
  click_button 'Create Site'
end

When /^I update the site name to "([^"]*)"$/ do |new_name|
  step %{I view the site settings}
  fill_in 'Name', :with => new_name
  click_button 'Update Site'
end

When /^I delete the site$/ do
  click_link 'Delete Site'
end

When /^I add the domain name "([^"]*)"$/ do |domain|
  click_link 'Add Domain Name'
  wait_for_ajax # wait for new input to be added
  find(:xpath, "//ol[contains(@class, 'domains_list')]/li[last()-1]/input").set domain
  click_button 'Update Site'
  find(:xpath, "//ol[contains(@class, 'domains_list')]/li[last()-1]/input").value.should == domain
end

When /^I add an additional domain name field and delete it$/ do
  steps %{
    And I view the site settings
    And I add the domain name "blog.com"
  }
  within(:xpath, "//ol[contains(@class, 'domains_list')]/li[last()-1]") do
    click_link 'Delete'
  end
  dialog_ok
end

When /^I add an additional meta tag with the name "([^"]*)" and the content "([^"]*)"$/ do |name, content|
  step %{I view the site settings}
  click_link 'Add Meta Tag'
  wait_for_ajax
  # find new name input
  find(:xpath, "//ol[contains(@class, 'meta_tags')]/li[last()-1]/input[1]").set name
  # find new content input
  find(:xpath, "//ol[contains(@class, 'meta_tags')]/li[last()-1]/input[last()]").set content
  click_button 'Update Site'
  # check value was set
  find(:xpath, "//ol[contains(@class, 'meta_tags')]/li[last()-2]/input[1]").value.should == name 
  # check value was set
  find(:xpath, "//ol[contains(@class, 'meta_tags')]/li[last()-2]/input[last()]").value.should == content 
end

When /^I add an additional meta tag and delete it$/ do
  steps %{
    And I view the site settings
    And I add an additional meta tag with the name "viewport" and the content "width=device-width, initial-scale=1.0"
  }
  within(:xpath, "//ol[contains(@class, 'meta_tags')]/li[last()-2]") do
    click_link 'Delete'
  end
  dialog_ok
end

Then /^I should see all the sites listed$/ do
  Site.all.each do |site|
    step %{I should see "#{site.name}" in the sites list}
  end
end

Then /^the site should be deleted$/ do
  page.should have_content '404'  
end

Then /^the additional domain name should be removed from the site$/ do
  wait_for_ajax
  all(:xpath, "//ol[contains(@class, 'domains_list')]/li/input").each do |input|
    input.value.should_not == 'blog.com'
  end
end


Then /^the additional meta tag should be removed from the site$/ do
  wait_for_ajax
  all(:xpath, "//ol[contains(@class, 'meta_tags')]/li/input[1]").each do |input|
    input.value.should_not == 'viewport'
  end
end
