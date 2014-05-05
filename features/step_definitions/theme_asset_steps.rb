Before('@theme_asset') do
  FactoryGirl.duplicate_attribute_assignment_from_initialize_with = false
end

After('@theme_asset') do
  AssetFixtureHelper.reset!
  FactoryGirl.duplicate_attribute_assignment_from_initialize_with = true
end

def theme_collection(name)
  tc = ThemeCollection.where(:name => name).first
end

Given /^these theme collections exist$/ do |table|
  table.hashes.each do |hash|
    create_theme_collection(hash)
  end
end

Given /^I view the theme collection "([^"]*)"$/ do |tc_name|
  step %{I view the theme collections in the site}
  click_link tc_name
end

When /^I change the theme collection name "([^"]*)" to "([^"]*)"$/ do |old_name, new_name|
  click_link 'Edit Collection Props'
  fill_in 'Name', :with => new_name
  click_button 'Update Theme Collection'
end

Given /^a theme asset named "(.*?)" exists in the collection "(.*?)"$/ do |filename, theme_collection_name|
  create_theme_asset(filename, theme_collection_name)
end

When /^I edit the theme collection "([^"]*)" and delete it$/ do |name|
  delete_within_item name, 'Delete Collection'
end

When /^I delete the theme collection "([^"]*)" from the theme collections list$/ do |name|
  delete_from_index "#tc_#{name}"
end

When /^I edit the theme asset "([^"]*)" and delete it$/ do |asset_name|
  steps %{
    And I create a theme asset named "#{asset_name}.png" 
    Then "#{asset_name}" should be listed within the image assets
  }
  click_link asset_name
end

When /^I delete the theme asset "([^"]*)" from the theme assets list$/ do |asset_name|
  steps %{
    And I create a theme asset named "#{asset_name}.png" 
    Then "#{asset_name}" should be listed within the image assets
  }
  delete_from_index '.theme_asset_image'  
end

Then /^I should see the theme collections$/ do
  @site.theme_collections do |tc|
    step %{I should see "#{tc.name}" in the theme collections}
  end
end

Then /^I should see all the theme assets in the theme collection "([^"]*)"$/ do |tc_name|
  @tc = theme_collection(tc_name)
  @tc.theme_assets.each do |theme_asset|
    step %{I should see "#{theme_asset.name}" in the theme assets list}
  end
end

Then /^the theme collection should be removed from the theme collections list$/ do
  removed_item_by_selector '#tc_blog'
end

Then /^"([^"]*)" should be listed within the image assets$/ do |asset_name|
  within '.theme_asset_image' do
    step %{I should see "#{asset_name}" in the theme assets list} 
  end
end

Then /^"([^"]*)" should be listed within the javascript assets$/ do |asset_name|
  within '.theme_asset_js' do
    step %{I should see "#{asset_name}" in the theme assets list} 
  end
end

Then /^"([^"]*)" should be listed within the css assets$/ do |asset_name|
  within '.theme_asset_css' do
    step %{I should see "#{asset_name}" in the theme assets list} 
  end
end

Then /^"([^"]*)" should be listed within the other assets$/ do |asset_name|
  tc = ThemeCollection.where(:name => 'blog').first
  within '.theme_asset_other' do
    step %{I should see "#{asset_name}" in the theme assets list} 
  end
end

Then /^the theme asset image "([^"]*)" should be removed$/ do |asset_name|
  removed_item_by_selector '.theme_asset_image'
end

Then /^the theme asset should be removed from the theme assets list$/ do
  removed_item_by_selector '.theme_asset_image'
end
