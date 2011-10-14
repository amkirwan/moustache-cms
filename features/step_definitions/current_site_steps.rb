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
