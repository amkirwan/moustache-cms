require 'spec_helper'

class Simple < MoustacheCms::Mustache::CmsPage
end

describe MoustacheCms::Mustache::PageTags do
  include_context "mustache page setup"

  before(:each) do
    @page.page_parts << FactoryGirl.build(:page_part, 
                                      :name => "main_content", 
                                      :content => "# main_content #\n {{{ page_part_content }}}",
                                      :filter_name => "markdown") 
    @page.save
    @cmsp.instance_variable_set("@page", @page)
  end


  describe "it should define the ghost method calls" do
    specify { @cmsp.respond_to?(:editable_text_content).should be_true }
    specify { @cmsp.respond_to?(:page_part_content).should be_true }
  end

  describe "title tags" do
    it "should return the page title" do
      @cmsp.title_tag.should == %{<title>#{@page.title}</title>\n}
    end  

    it "should return the page title" do
      @cmsp.page_title.should == @page.title
      @cmsp.article_title.should == @page.title
    end
  end

  describe "it should create methods from ghost method calls" do
    it "should define a method for the call to editable_text_(name)" do
      @cmsp.editable_text_content
      @cmsp.class.attribute_method_generated?(:editable_text_content).should be_true   
    end  

    it "should define a method for the call to page_part_(name)" do
      @cmsp.page_part_content
      @cmsp.class.attribute_method_generated?(:page_part_content).should be_true   
    end
  end
  
  describe "it should render the page_part with the correct filter" do
    it "should return the page part rendered as markdown" do
      @cmsp.editable_text_content.should == "<p>define editable text method <strong>strong</strong></p>"    
    end
    
    it "should return the page part rendered as textile" do
      @page.page_parts.where(:name => 'content').first.filter_name = "textile"
      @cmsp.editable_text_content.should == "<p>define editable text method <b>strong</b></p>"    
    end
    
    it "should render as HTML" do
      @page.page_parts.where(:name => 'content').first.filter_name = "html"
      @cmsp.editable_text_content.should == "define editable text method **strong**"    
    end
  end
  describe "render page part in another" do
    it "should render the page part content within main_content" do
      @cmsp.page_part_main_content.should == "<h1>main_content</h1>\n\n<p>define editable text method <strong>strong</strong></p>"
    end  

  end
  
end
