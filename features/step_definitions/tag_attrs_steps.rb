Given /^the asset "([^"]*)" with the custom tag attribute "([^"]*)" and a value of "([^"]*)"$/ do |asset, name, value|
  When %{I go to the admin theme assets page}
  And %{I follow "#{asset}"}
  And %{I follow "Add Tag Attribute"}
  And %{I fill in "tag_attr_name" with "#{name}"}
  And %{I fill in "tag_attr_value" with "#{value}"}
  And %{I press "Create Tag Attribute"}
  Then %{I should now be editing the theme asset "theme_css"}
end
