When /^I go into debug mode$/ do
  require 'ruby-debug'
  debugger
  1
end

Then /^I should see the "([^"]*)" button$/ do |name|
  find_button(name).should_not be_nil
end

Then /^I should not see the "([^\"]*)" button in "([^\"]*)"$/ do |button_value, parent|
  find(parent).should_not have_button(button_value)
end