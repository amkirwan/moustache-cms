def find_layout(layout_name)
  layout = Layout.where(:name => layout_name).first
end

Given /^these layouts exist in the site "([^\"]*)" created by user "([^\"]*)"$/ do |site, username, table|
  user = User.find_by_username(username)
  site = Site.match_domain(site).first
  table.hashes.each do |hash|
    Factory(:layout, :site => site, :name => hash[:name], :created_by => user, :updated_by => user, :content => hash[:content])
  end
end

When /^(?:|I )edit the layout "([^\"]*)"$/ do |layout_name|
  layout = find_layout(layout_name)
  step %{I go to the edit admin layout page for "#{layout.to_param}"}
end

When /^I follow "([^"]*)" associated with the layout "([^"]*)"$/ do |delete, layout_name|
  layout = find_layout(layout_name)
  step %{I follow "#{delete}" within "tr#layout_#{layout_name}"}
end

Then /^(?:|I )should view the page for layout "([^\"]*)"$/ do |layout_name|
  layout = find_layout(layout_name)
  step %{I should be on the edit admin layout page for "#{layout.to_param}"}
end

Then /^(?:|I )should now be editing the layout "([^\"]*)"$/ do |layout_name|
  layout = find_layout(layout_name)
  step %{I should be on the edit admin layout page for "#{layout.to_param}"} 
end
