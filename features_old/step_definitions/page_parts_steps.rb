def find_page(page_title)
  page = Page.where(:title => page_title).first
end


Then /^I should now be on the new admin page part page for the page "([^"]*)"$/ do |page_name|
  page = find_page(page_name)
  Then %{I should be on the new admin page part page for page "#{page.id}"}
end

When /^the default additional page part exists in the page "([^"]*)"$/ do |page_name|
  page = find_page(page_name)

  When %{I go to the admin pages page}
  And %{I follow "#{page_name}"}
  And %{I follow "Add Page Part"}
  Then %{I should now be editing the page "#{page_name}"}
end


    
