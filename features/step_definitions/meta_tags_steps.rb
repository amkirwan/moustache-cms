Given /^the page "([^"]*)" with a custom meta tag "([^"]*)" with the content "([^"]*)"$/ do |page_name, meta_name, meta_content|  
    When %{I go to the admin pages page}
    And %{I follow "#{page_name}"}
    And %{I follow "Add Meta Tag"}
    And %{I fill in "meta_tag_name" with "#{meta_name}"}
    And %{I fill in "meta_tag_content" with "#{meta_content}"}
    And %{I press "Create Meta Tag"}
    Then %{I should now be editing the page "foobar"}
    And %{I should see "Successfully created the meta tag DC.author"}
end

Then /^I should now be editing the meta tag "([^"]*)" for the page "([^\"]*)"$/ do |meta_name, page_name|
  page = Page.where(:title => page_name).first
  meta_tag = page.meta_tags.where(:name => meta_name).first
  Then %{I should be on the edit admin page "#{page.to_param}" meta tag page for "#{meta_tag.to_param}"}
end
