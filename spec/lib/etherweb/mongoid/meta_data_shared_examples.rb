require "spec_helper"

shared_examples_for "meta_data" do
  
  before(:each) do
    @meta = @page if !@page.nil?
    @meta = @site if !@site.nil?
  end
 
  it "should return the defualt meta data tag title" do
    @meta.class.default_meta_tags.should have_key(:title)
  end
  
  it "should return the defualt meta data tag keywords" do
    @meta.class.default_meta_tags.should have_key(:keywords)
  end
  
  it "should return the defualt meta data tag title" do
    @meta.class.default_meta_tags.should have_key(:description)
  end
end
