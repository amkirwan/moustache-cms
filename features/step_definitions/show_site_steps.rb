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
