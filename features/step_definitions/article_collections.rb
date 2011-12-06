def find_article_collection(name)
  @article_collection = ArticleCollection.where(:name => name).first
end

Given /^these article collections exist in the site "([^"]*)" created by user "([^"]*)"$/ do |site, username, table|
  user = User.find_by_username(username)
  site = Site.match_domain(site).first
  table.hashes.each do |hash|
    Factory(:article_collection, :site => site, :name => hash[:name], :created_by => user, :updated_by => user)
  end
end

Given /^theses articles exist in the article collection "([^"]*)"$/ do |collection_name, table|
  collection = find_article_collection(collection_name)
  table.hashes.each do |hash|
    article = Factory.build(:article, :site => collection.site, :title => hash[:title], :created_by => collection.created_by, :updated_by => collection.updated_by)
    collection.articles << article 
  end
end

When /^I view the article collections$/ do
  visit admin_article_collections_path
end

When /^I create a article collection named "([^"]*)"$/ do |name|
  fill_in 'Name', :with => name
  click_on "Save Article Collection" 
end

When /^I view the article collection "([^"]*)"$/ do |name|
  visit admin_article_collections_path
  click_on "foobar"
end

When /^I change the name to "([^"]*)"$/ do |new_name|
  fill_in 'Name', :with => new_name
end

When /^I press the button "([^"]*)"$/ do |button_name|
  click_on button_name
end

Then /^I should see all the article collections$/ do |table|
  table.hashes.each do |hash|
    page.should have_content hash[:name]
  end
end

Then /^I should see an article collection named "([^"]*)"$/ do |name|
  page.should have_content name
end

