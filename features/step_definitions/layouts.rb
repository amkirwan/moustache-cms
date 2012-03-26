def find_layout_by_name(name)
  Layout.where(:site => @site, :name => name).first
end

Given /I view the layouts in the site$/ do
  visit '/admin/layouts'
end

Given /^these layouts exist$/ do |table|
  table.hashes.each do |hash|
    create_layout(hash[:name])
  end
end

Given /^I want to create a new layout in the site$/ do
  visit '/admin/layouts'
  click_link 'New Layout'
end

When /^I create a layout with the name "([^"]*)"$/ do |name|
  fill_in 'Name*', :with => name
  fill_in 'Content', :with => '<!DOCTYPE html>'
  click_button 'Create Layout'
end

When /^I change the layout name to "([^"]*)"$/ do |new_name|
  click_link 'foobar'
  fill_in 'Name*', :with => new_name
  click_button 'Update Layout'
end

When /^I edit the layout "([^"]*)" and delete it$/ do |layout_name|
  click_link layout_name
  click_link 'Delete Layout'
end

When /^I delete the layout "([^"]*)" from the layouts list$/ do |layout_name|
  within "tr#layout_#{layout_name}" do
    click_link 'Delete'
  end
  dialog_ok
  wait_for_ajax
end

Then /^I should see "([^"]*)" in the layouts list$/ do |name|
  path_should_be admin_layouts_path
  page.should have_content name
end

Then /^I should see the layouts listed$/ do
  @site.layouts.each do |site_layout|
    step %{I should see "#{site_layout.name}" in the layouts list}
  end
end

Then /^the layout should be removed from the layouts list$/ do
  page.should_not have_selector 'tr#layout_foobar'
end
