def find_article_collection(name)
  @article_collection = ArticleCollection.where(:name => name).first
end

Given /^these article collections exist in the site "([^"]*)" created by user "([^"]*)"$/ do |site, username, table|
  user = User.find_by_username(username)
  site = Site.match_domain(site).first
  table.hashes.each do |hash|
    Factory(:article_collection, :site => site, :name => hash[:name], :editors => [user], :created_by_id => user.id, :updated_by_id => user.id)
  end
end


Given /^these articles exist in the article collection "([^"]*)"$/ do |collection_name, table|
  find_article_collection(collection_name)
  @article_collection.articles = []
  table.hashes.each do |hash|
    @article_collection.articles << Factory.build(:article, :title => hash[:title], :creator_id => @article_collection.created_by_id, :updator_id => @article_collection.updated_by_id)
    @article_collection.save
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
  click_on name
end

When /^I change the name to "([^"]*)"$/ do |new_name|
  fill_in 'Name', :with => new_name
end

When /^I click the link "([^"]*)"$/ do |link_name|
  click_on link_name
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

Then /^I should see the articles in the collection$/ do |table|
  table.hashes.each do |hash|
    page.should have_content hash[:title]
  end
end

Then /^I should see the message "([^"]*)"$/ do |message|
  page.should have_content message 
end

Then /^I should be returned to the "([^"]*)"$/ do |page_name|
  page_name.gsub!(/\s+/, '_')
  page_name.gsub!('page', 'path')
  uri = URI.parse(current_url)
  "#{uri.path}".should == admin_article_collections_path
end



