def find_layout(layout_name)
  layout = Layout.where(:name => layout_name).first
end

Given /^these layouts exist$/ do |table|
  table.hashes.each do |hash|
    Layout.make!(:name => hash[:name], :content => hash[:content])
  end
end

When /^(?:|I )edit the layout "([^\"]*)"$/ do |layout_name|
  layout = layout = find_layout(layout_name)
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