def find_layout(layout_name)
  layout = Layout.where(:name => layout_name).first
end

Given /^these layouts exist in the site "([^\"]*)" created by user "([^\"]*)"$/ do |site, puid, table|
  user = User.find_by_puid(puid)
  site = Site.match_domain(site).first
  table.hashes.each do |hash|
    Factory(:layout, :site => site, :name => hash[:name], :created_by => user, :updated_by => user, :content => hash[:content])
  end
end

When /^(?:|I )edit the layout "([^\"]*)"$/ do |layout_name|
  layout = find_layout(layout_name)
  When %{I go to the edit admin layout page for "#{layout.to_param}"}
end

Then /^(?:|I )should view the page for layout "([^\"]*)"$/ do |layout_name|
  layout = find_layout(layout_name)
  Then %{I should be on the edit admin layout page for "#{layout.to_param}"}
end

Then /^(?:|I )should now be editing the layout "([^\"]*)"$/ do |layout_name|
  layout = find_layout(layout_name)
  Then %{I should be on the edit admin layout page for "#{layout.to_param}"} 
end