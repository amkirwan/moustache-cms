def layout_content
'
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
</htm
'
end

def page_content
  "<p>Hello, World!</p>"
end

Given /^the page "([^"]*)" exists with the layout "([^"]*)" in the site "([^"]*)"$/ do |page_name, layout_name, site|
  FactoryGirl.create(:page, :title => page_name,
                 :site => Site.match_domain(site).first,
                 :page_parts => [ FactoryGirl.build(:page_part, :name => "content", :content => page_content) ],
                 :layout => FactoryGirl.create(:layout, :name => layout_name, :content => layout_content))
end

When /^I go to the sites homepage$/ do
  visit '/'
end

Then /^I should see the homepage$/ do
  page.should have_content 'Hello, World!'
end
