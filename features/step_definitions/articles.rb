When /^I view the articles in the collection "([^"]*)"$/ do |ac_name|
  ac = find_article_collection(ac_name)
  visit admin_article_collection_articles_path(ac.id)
end

Then /^I should see all the articles in the collection "([^"]*)"$/ do |ac_name|
  ac = find_article_collection(ac_name)
  ac.articles.each do |article|
    page.should have_content(article.title.gsub('_', ' '))
  end
end
