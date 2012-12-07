def homepage_layout
  <<-EOS
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="utf-8" />
        {{{ meta_data }}}
        <title>BWH Anesthesia, Perioperative and Pain Medicine</title>
      </head>
      <body id="index" class="home">
        <div id="content">
          {{{ yield }}}
        </div>
      </body>
    </html>
  EOS
end

def homepage_content
  "<p>Hello, World!</p>"
end

def page_content(page_name)
  <<-PAGE_CONTENT
    #{page_name}
  PAGE_CONTENT
end

def get_homepage(site)
  Site.match_domain(site).first.homepage
end

def articles_list
  <<-PAGE_CONTENT
    {{#articles_for_blog}}
      <h1>{{title}}</h1>
      \n\nCheckout the [{{title}}]({{permalink}})
    {{/articles_for_blog}}
  PAGE_CONTENT
end

def article_content
  <<-PAGE_CONTENT
    {{#article}}
      <h1>{{title}}</h1>
      <p>{{content}}</p>
      {{#comments}}
        {{author}}
        {{author_email}}
        {{content}}
      {{/comments}}
    {{/article}}
    {{#form_for_comment}}class: new-comment{{/form_for_comment}}
  PAGE_CONTENT
end

def page_parts_for_article(ac_name=nil)
  [ FactoryGirl.build(:page_part, name: "content", content: "{{{articles_or_article}}}"), 
    FactoryGirl.build(:page_part, name: '_articles', content: articles_list, filter_name: 'markdown'), 
    FactoryGirl.build(:page_part, name: '_article', content: article_content)]
end

#######

Given /^the Homepage exists in the site "([^"]*)"$/ do |site|
  FactoryGirl.create(:page, :title => 'Homepage',
                 :site => Site.match_domain(site).first,
                 :page_parts => [ FactoryGirl.build(:page_part, :name => "content", :content => homepage_content) ],
                 :layout => FactoryGirl.create(:layout, :name => 'homepage_layout', :content => homepage_layout))
end

When /^I go to the sites homepage$/ do
  visit '/'
end

Then /^I should see the homepage$/ do
  page.should have_content 'Hello, World!'
end

Given /^the Homepage is a blog in the site "(.*?)"$/ do |site|
  FactoryGirl.create(:page, :title => 'Homepage',
                 :site => Site.match_domain(site).first,
                 :page_parts => page_parts_for_article('homepage'),
                 :layout => FactoryGirl.create(:layout, :name => 'homepage_layout', :content => homepage_layout))
end


Given /^the "(.*?)" page exists in the site "(.*?)"$/ do |page_name, site|
  step %{the Homepage exists in the site "#{site}"} 
  FactoryGirl.create(:page, 
                     parent: get_homepage(site),
                     :title => page_name,
                     :site => Site.match_domain(site).first,
                     :page_parts => [ FactoryGirl.build(:page_part, :name => "content", :content => page_content(page_name))],
                     :layout => FactoryGirl.create(:layout, :name => 'homepage_layout', :content => homepage_layout),
                     :slug => "#{page_name}",
                     :full_path => "#{page_name}")

end

Given /^the "(.*?)" collection page exists in the site "(.*?)"$/ do |ac_name, site|
  step %{the Homepage exists in the site "#{site}"} 
  FactoryGirl.create(:page, 
                     parent: get_homepage(site),
                     :title => ac_name,
                     :site => Site.match_domain(site).first,
                     :page_parts => page_parts_for_article(ac_name),
                     :layout => FactoryGirl.create(:layout, :name => 'homepage_layout', :content => homepage_layout),
                     :slug => "#{ac_name}",
                     :full_path => "#{ac_name}")

end

When /^I go to the sites "(.*?)" page$/ do |page_name|
  visit "/" + page_name
end

When /^I go to the sites homepage with the article collection "(.*?)"$/ do |ac_name|
  @ac = article_collection(ac_name)
  @ac.layout.update_attributes(content: homepage_layout)
  step %{I go to the sites homepage}
end

When /^I view the article "(.*?)"$/ do |title|
  click_link title
end

When /^I view the "(.*?)" post with the title "(.*?)"$/ do |ac_name, title|
  # set the correct layout for the article collection
  @ac = article_collection(ac_name)
  @ac.layout.update_attributes(content: homepage_layout)
  step %{I go to the sites "#{ac_name}" page}
  step %{I should see the list of article titles for the article collection "#{ac_name}"}
  click_link title
end

When /^I go to the article "(.*?)" in the collection "(.*?)"$/ do |title, ac_name|
  step %{I go to the sites homepage with the article collection "#{ac_name}"}
  step %{I view the article "#{title}"}
end

Then /^I should see the "(.*?)" page$/ do |page_name|
  page.should have_content "#{page_name}"
end

Then /^I should see the list of article titles for the article collection "(.*?)"$/ do |ac_name|
  @ac = article_collection(ac_name)
  @ac.articles.each do |article|
    page.should have_content "#{article.title}"
  end
end

Then /^I should see the blog post "(.*?)"$/ do |title|
  article = @site.articles.where(title: title).first
  page.should have_content "#{article.title}"
  page.should have_content "#{article.content}"
end

When /^I add a comment with the name "(.*?)", email "(.*?)" and comment "(.*?)"$/ do |author_name, author_email, content|
  @author_name = author_name
  @author_email = author_email
  @content = content
  fill_in 'comment[author]', with: author_name
  fill_in 'comment[author_email]', with: author_email
  fill_in 'comment[content]', with: content
  click_button 'Submit Comment'
end

Then /^I should see the comment on the page$/ do
  page.should have_content @author_name
  page.should have_content @author_email
  page.should have_content @content
end
