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

Given /^I view the (.*) in the site$/ do |index_page|
  visit "/admin/#{index_page.gsub(/[\s]/, '_')}"
end

Then /^I should see "([^"]*)" in the (?:.*) list$/ do |content|
  page.should have_content content
end

Then /^I should see the flash message "(.*)"$/ do |message|
  page.should have_content message
end
