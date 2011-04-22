Then /^I should see the "([^"]*)" button$/ do |name|
  find_button(name).should_not be_nil
end