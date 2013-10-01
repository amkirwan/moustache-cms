require "spec_helper"

describe MoustacheCms::Mustache::CmsPage do
  include_context "mustache page setup"

  describe "initialize" do
    it "should set controller ivars to cms_page instance" do
      @cmsp.instance_variable_defined?(:@page).should be_true
    end
    
  end
  
  describe "yield for non xhr requests" do
    it "should set the template to the layout content" do
      @cmsp.template.to_s.should == "Hello, World!"
    end   

    it "should return the first page part rendered" do
      @cmsp.yield.to_s.should == "Page Part Hello, World!"
    end
  end

  describe "when the request is xhr" do
    before(:each) do
      @request.stub(:xhr?).and_return(true)
      @page.page_parts << FactoryGirl.build(:page_part, name: '_ajax', content: 'ajax content', filter_name: 'javascript')
    end

    it "should return yield for the template" do
      @cmsp.template.to_s.should == "{{{yield}}}"
    end

    it "should return the page part named _ajax" do
      @cmsp.yield.to_s.should == "ajax content"
    end
  end

end
