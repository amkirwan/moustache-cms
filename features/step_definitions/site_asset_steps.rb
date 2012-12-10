def asset_collection(name)
  AssetCollection.where(:name => name).first
end

Given /^I view the site assets for the site$/ do
  visit '/admin/asset_collections'
end

Given /^these asset collections exist$/ do |table|
  table.hashes.each do |hash|
    create_asset_collection(hash[:name])
  end
end

Given /^I view the site asset collection "([^"]*)"$/ do |name|
  steps %{
    Given I view the site assets for the site
    When I create a new site asset collection with the name "#{name}"
  }
  click_link name
end

When /^I create a new site asset collection with the name "([^"]*)"$/ do |name|
  click_link 'New Asset Collection'
  fill_in 'Name', :with => name
  click_button 'Save Collection'
end

When /^I change the asset collection name "([^"]*)" to "([^"]*)"$/ do |old_name, new_name|
  step %{I create a new site asset collection with the name "#{old_name}"}
  step %{I view the site assets for the site}
  click_link old_name
  click_link 'Edit Collection Props'
  fill_in 'Name', :with => new_name
  click_button 'Update Collection'
end

When /^I edit the site asset collection "([^"]*)" and delete it$/ do |name|
  click_link name
  click_link 'Delete Collection'
end

When /^I delete the site assets collection "([^"]*)" from the articles list$/ do |name|
  within "tr#ac_#{name}" do
    click_link 'Delete'
  end
  dialog_ok
  wait_for_ajax
end

When /^I edit the site asset "([^"]*)" and delete it$/ do |name|
  click_link name
  click_link 'Delete Site Asset'
end

When /^I create the site asset named "([^"]*)"$/ do |filename|
  attach_file 'Asset Source*', File.join(Rails.root, 'spec', 'fixtures', 'assets', filename) 
  click_button 'Save Asset'
end

Then /^I should see the site assets collections$/ do
  @site.asset_collections.each do |ac|
    step %{I should see "#{ac.name}" in the site assets collections list}
  end
end

Then /^the site asset collection "([^"]*)" should be removed from the asset collections list$/ do |name|
  within '.asset_collections' do
    page.should_not have_content name
  end
end

Then /^the "([^"]*)" should be added to the asset collection$/ do |file_name|
  pending
end

Then /^"([^"]*)" should be listed within the site assets$/ do |asset_name|
  within '.show_asset_collection' do
    step %{I should see "#{asset_name}" in the theme assets list} 
  end
end

Then /^I should not see the "(.*?)" in the image list$/ do |name|
  within '.show_asset_collection' do
    page.should_not have_content name 
  end
end
