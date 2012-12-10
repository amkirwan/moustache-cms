def wait_for_ajax
  sleep 1
end

def pause_for_step
  sleep 1  
end

def dialog_ok 
  page.driver.browser.switch_to.alert.accept
end

Given /^I visit "(.*)"$/ do |path|
  visit path
end

Then /^show me the page$/ do
  save_and_open_page
end

