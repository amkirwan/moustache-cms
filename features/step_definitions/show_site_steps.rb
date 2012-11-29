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
  "<p>#{page_name}</p>"
end

def get_homepage(site)
  Site.match_domain(site).first.homepage
end

def page_parts_for_article(ac_name)
  [ FactoryGirl.build(:page_part, name: "content", content: "{{{ articles_or_article }}}"), 
    FactoryGirl.build(:page_part, name: '_articles', content: "{{#articles_for_blog}}<h1>{{title}}</h1>\nCheckout the [{{title}}]({{permalink}}){{/articles_for_blog}}", filter_name: 'markdown'), 
    FactoryGirl.build(:page_part, name: '_article', content: "{{#article}}<h1>{{title}}</h1><p>{{content}}</p>{{/article}}") ]
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

When /^I view the "(.*?)" post with the title "(.*?)"$/ do |ac_name, title|
  # set the correct layout for the article collection
  @ac = article_collection(ac_name)
  @ac.layout.update_attributes(content: homepage_layout)
  step %{I go to the sites "#{ac_name}" page}
  step %{I should see the list of article titles for the article collection "#{ac_name}"}
  click_link title
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
  article = @ac.articles.where(title: title).first
  page.should have_content "#{article.title}"
  page.should have_content "#{article.content}"
end
