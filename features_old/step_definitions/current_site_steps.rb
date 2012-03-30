def find_site(site_name)
  Site.where(:name => site_name).first
end

When /^(?:|I )edit the current site "([^\"]*)"$/ do |site_name|
  site = find_site(site_name) 
  When %{I go to the edit admin current site page for "#{site.to_param}"}
end

Then /^I should now be editing the current site "([^"]*)"$/ do |site_name|
  site = find_site(site_name) 
  Then %{I should be on the edit admin current site page for "#{site.to_param}"}
end


When /^I edit the current site "([^"]*)" with the additional domain "([^"]*)"$/ do |site_name, domain_name|
  site = find_site(site_name) 
    When %{I edit the current site "foobar"}
    And %{I follow "Add Domain Name"}

    When %{I fill in "site[domain_name]" with "example.org"}
    And %{I press "Create Domain Name"}
    Then %{the "site[domain_names][]" field should contain "example.org"}
end
