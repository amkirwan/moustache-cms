def layout_content
'
  !!! 5
  %html
    %head{:charset => "UTF-8"}
      %title Etherweb Admin
      = stylesheet_link_tag :all
      = javascript_include_tag :defaults
      = csrf_meta_tag
    %body
    - flash.each do |name, msg|
      = content_tag :div, msg, :id => "flash_#{name}"
    #wrapper
      #content
      = yield
'
end

def page_content
  "<p>Hello, World!</p>"
end

Given /^the page "([^"]*)" exists with the layout "([^"]*)"$/ do |page_name, layout_name|
  Factory(:page, :title => page_name,
                 :page_parts => [ Factory.build(:page_part, :name => "content", :content => page_content) ],
                 :layout => Layout.make!(:name => layout_name, :content => layout_content))
end
