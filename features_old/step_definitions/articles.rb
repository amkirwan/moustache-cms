When /^I view the articles in the collection "([^"]*)"$/ do |ac_name|
  ac = find_article_collection(ac_name)
  visit admin_article_collection_articles_path(ac.id)
end

When /^I create an article titled "([^"]*)"$/ do |title|
  fill_in 'Title*', :with => title
  fill_in 'Content*', :with => "post comment"
  click_on "Create Article" 
end

When /^I change the title of the article to "([^"]*)"$/ do |title|
  fill_in 'Title*', :with => title
  click_on "Update Article" 
end

Then /^I should see all the articles in the collection "([^"]*)"$/ do |ac_name|
  ac = find_article_collection(ac_name)
  ac.articles.each do |article|
    page.should have_content(article.title.gsub('_', ' '))
  end
end

Then /^I should see an article titled "([^"]*)"$/ do |title|
    page.should have_content(title)
end
