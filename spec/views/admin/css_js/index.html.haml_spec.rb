# admin::theme_asset index spec
require 'spec_helper'

describe "admin/css_files/index.html.haml" do
  let(:theme_css_js_files) { [stub_model(ThemeCssFile, :name => "foobar")] }
  
  before(:each) do
    assign(:theme_css_js_files, theme_css_js_files)
  end
  
  it "should display the css filename" do
    render
    rendered.should contain("foobar")
  end
  
  
  it "should make the css filename a clickable link to edit" do
    render
    theme_css_js_files.each do |css|
      rendered.should have_selector("li##{css.name}") do |li|
        li.should have_selector("a", :content => "#{css.name}", :href => edit_admin_css_file_path(css))
      end
    end
  end
  
  it "should render a delete button to destroy the css file" do
    render
    theme_css_js_files.each do |css|
      rendered.should have_selector("form", :method => "post", :action => admin_css_file_path(css)) do |f|
        f.should have_selector("input", :value => "delete")
      end
    end
  end
   
  it "should render a link to add a new page" do
    render
    rendered.should have_selector("a", :href => new_admin_css_file_path) do |link|
      link.should contain("Add Css File")
    end
  end
  
end