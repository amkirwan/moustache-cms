Given /^these article collections exist in the site "([^"]*)" created by user "([^"]*)"$/ do |site, username, table|
  user = User.find_by_username(username)
  site = Site.match_domain(site).first
  table.hashes.each do |hash|
    Factory(:article_collection, :site => site, :name => hash[:name], :created_by => user, :updated_by => user)
  end
end

When /^I view the article collections$/ do
  visit admin_article_collections_path
end

Then /^I should see all the article collections$/ do
  page.should have_content 'foobar'
  page.should have_content 'bar' 
end
