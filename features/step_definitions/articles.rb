def article_collection(name)
  ArticleCollection.where(:name => name).first
end

Given /^these article collections exist$/ do |table|
  table.hashes.each do |hash|
    create_article_collection(hash[:name])
  end
end

Given /^these articles exist in the collection "([^"]*)"$/ do |ac_title, table|
  ac = article_collection(ac_title)
  table.hashes.each do |hash|
    create_article(hash[:title], ac)
  end
end

Given /^I view the article collection "([^"]*)"$/ do |ac_title|
  visit '/admin/article_collections'
  click_link ac_title
end

When /^I create a article collection with the name "([^"]*)"$/ do |name|
  click_link 'New Article Collection'
  fill_in 'Name', :with => name
  check 'amkirwan'
  click_button 'Save Article Collection'
end

When /^I change the article collection "([^"]*)" to "([^"]*)"$/ do |old_name, new_name|
  click_link old_name
  click_link 'Edit Collection Props'
  fill_in 'Name', :with => new_name
  click_button 'Update Article Collection'
end

When /^I edit the article collection "([^"]*)" and delete it$/ do |name|
  delete_within_item name, 'Delete Collection'
end

When /^I delete the article collection "([^"]*)" from the article collections list$/ do |name|
  delete_from_index("tr#ac_#{name}")
end

When /^I create a article "([^"]*)"$/ do |title|
  click_link 'New Article'
  fill_in 'Title', :with => title
  click_button 'Create Article'
end

When /^I update the article "([^"]*)" to "([^"]*)"$/ do |old_title, new_title|

  click_link old_title
  fill_in 'Title', :with => new_title
  click_button 'Update Article'
end

When /^I edit the article "([^"]*)" and delete it$/ do |title|
  click_link title
  click_link 'Delete Article'
end

When /^I delete the article "([^"]*)" from the articles list$/ do |title|
  within "tr##{title}" do
    click_link 'Delete'
  end
  dialog_ok
  wait_for_ajax
end

Then /^I should see "([^"]*)" in the article collections list$/ do |name|
  path_should_be admin_article_collections_path
  page.should have_content name
end

Then /^I should see "([^"]*)" in the articles list$/ do |title|
  page.should have_content title
end

Then /^I should see the article collections$/ do
  @site.article_collections.each do |ac|
    step %{I should see "#{ac.name}" in the article collections list}
  end
end

Then /^I should see all the articles in the article collection "([^"]*)"$/ do |ac_title|
  @ac = article_collection(ac_title)
  @ac.articles.each do |ac|
    step %{I should see "#{ac.title}" in the articles list}
  end
end

Then /^the article collection "([^"]*)" should be removed from the article collections list$/ do |name|
  page.should_not have_selector("tr#ac_#{name}")
end

Then /^the article "([^"]*)" should be removed from the articles in the article collection blog$/ do |title|
  within '.articles' do
    page.should_not have_selector("tr##{title}")
  end
end

Then /^the article "([^"]*)" should be removed from the article collections list$/ do |title|
  within '.articles' do
    page.should_not have_content 'title'
    page.should have_content 'Add An Article'
  end
end
