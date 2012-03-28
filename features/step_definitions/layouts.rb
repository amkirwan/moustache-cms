def find_layout_by_name(name)
  Layout.where(:site => @site, :name => name).first
end

Given /^these layouts exist$/ do |table|
  table.hashes.each do |hash|
    create_layout(hash[:name])
  end
end

Given /^I want to create a layout in the site$/ do
  new_form '/admin/layouts', 'New Layout'
end

When /^I create a layout with the name "([^"]*)"$/ do |name|
  fill_in 'Name*', :with => name
  fill_in 'Content', :with => '<!DOCTYPE html>'
  click_button 'Create Layout'
end

When /^I change the layout name "([^"]*)" to "([^"]*)"$/ do |old_name, new_name|
  click_link old_name
  fill_in 'Name*', :with => new_name
  click_button 'Update Layout'
end

When /^I edit the layout "([^"]*)" and delete it$/ do |layout_name|
  delete_within_item layout_name, 'Delete Layout'
end

When /^I delete the layout "([^"]*)" from the layouts list$/ do |layout_name|
  delete_from_index "tr#layout_#{layout_name}"
end

Then /^I should see the layouts listed$/ do
  @site.layouts.each do |site_layout|
    step %{I should see "#{site_layout.name}" in the layouts list}
  end
end

Then /^the layout should be removed from the layouts list$/ do
  removed_item_by_selector 'tr#layout_foobar'
end
