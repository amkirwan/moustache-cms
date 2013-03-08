def path_should_be(path)
  current_path.should == path
end

def delete_within_item(item_link, delete_link)
  click_link item_link
  click_link delete_link
end

def delete_from_index(id)
  within "#{id}" do
    click_link 'Delete'
  end
  dialog_ok
  wait_for_ajax
end

def removed_item_by_selector(id)
  page.should_not have_selector id
end

def new_form(path, new_link)
  visit "/admin/#{path}"
  click_link new_link
end

def add_meta_tag(name, content, submit)
  click_link 'Add Meta Tag'
  wait_for_ajax
  # find new name input
  find(:xpath, "//ol[contains(@class, 'meta_tags')]/li[last()-1]/input[1]").set name
  # find new content input
  find(:xpath, "//ol[contains(@class, 'meta_tags')]/li[last()-1]/input[last()]").set content
  click_button submit
end

Given /^I view the (.*) in the site$/ do |index_page|
  visit "/admin/#{index_page.gsub(/[\s]/, '_')}"
end

When /^I expand "([^"]*)"$/ do |fieldset_legend|
  page.find('legend', :text => fieldset_legend).click
  wait_for_ajax
end

When /^I delete the last meta tag added to the (.*)$/ do |page|
  step %{I expand "Page Meta Tags"} if page == "page"
  within(:xpath, "//ol[contains(@class, 'meta_tags')]/li[last()-2]") do
    click_link 'Delete'
  end
  dialog_ok
end

When /^I add an additional meta tag with the name "([^"]*)" and the content "([^"]*)" and click "([^"]*)"$/ do |name, content, button_name|
  add_meta_tag(name, content, button_name)
end


Then /^the meta tag "([^"]*)" should be removed from the page$/ do |meta_tag_name|
  wait_for_ajax
  all(:xpath, "//ol[contains(@class, 'meta_tags')]/li/input").each do |input|
    input.value.should_not == meta_tag_name
  end
end

Then /^I should see "([^"]*)" in the (?:.*) list$/ do |content|
  page.should have_content content
end


Then /^I should not see "([^"]*)" in the (?:.*) list$/ do |content|
  page.should_not have_content content
end

Then /^I should see the flash message "(.*)"$/ do |message|
  page.should have_content message
end
