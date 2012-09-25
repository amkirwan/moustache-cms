require "spec_helper"

class Simple < MoustacheCms::Mustache::CmsPage
end

describe MoustacheCms::Mustache::CmsPage do
  include_context "mustache page setup"

  describe "initialize" do
    it "should set controller ivars to cms_page instance" do
      @cmsp.instance_variable_defined?(:@page).should be_true
    end
    
    it "should set the template to the layout content" do
      @cmsp.template.to_s.should == "Hello, World!"
    end   
  end
  
  describe "yield" do
    it "should return the first page part rendered" do
      @cmsp.yield.to_s.should == "Page Part Hello, World!"
    end
  end
  
end
