def wait_for_ajax
  sleep 1
end

def dialog_ok 
  page.driver.browser.switch_to.alert.accept
end

Given /^I visit "(.*)"$/ do |path|
  visit path
end

Then /^I should see the flash message "(.*)"$/ do |message|
  page.should have_content message
end

