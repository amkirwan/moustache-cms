Then /^I should see "([^"]*)" button/ do |name|
  find_button(name).should_not be_nil
end