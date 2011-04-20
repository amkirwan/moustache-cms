require "spec_helper"

describe Etherweb::CmsPage do
  
  before(:each) do
    @controller = CmsSiteController.new
    @page = Factory.build(:no_root_page)
    @page.page_parts << Factory.build(:page_part, 
                                      :name => "content", 
                                      :content => "define_editable_text_method **strong**", 
                                      :filter => Filter.find_by_name(:markdown))
    @controller.instance_variable_set(:@page, @page)
    @cmsp = Etherweb::CmsPage.new(@controller)
  end
  
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
  
  describe "define_editable_text_method" do    
    it "should define the method" do
      @cmsp.respond_to?(:editable_text_content).should be_true
    end
    
    it "should return the page parts contents" do
      if @cmsp.editable_text_content
        @cmsp.editable_text_content.should == "<p>define_editable_text_method <strong>strong</strong></p>\n"    
      end   
    end
  end
  
  describe "it should render with the correct filter" do
    it "should return the page part rendered as markdown" do
      if @cmsp.editable_text_content
        @cmsp.editable_text_content.should == "<p>define_editable_text_method <strong>strong</strong></p>\n"    
      end
    end
    
    it "should return the page part rendered as textile" do
      @page.page_parts.last.filter = Filter.find_by_name(:textile)
      if @cmsp.editable_text_content
        @cmsp.editable_text_content.should == "<p>define_editable_text_method <b>strong</b></p>"    
      end    
    end
    
    it "should render as plain html" do
      @page.page_parts.last.filter = Filter.find_by_name(:html)
      if @cmsp.editable_text_content
        @cmsp.editable_text_content.should == "<p>define_editable_text_method <b>strong</b></p>"    
      end
    end
  end 
end 