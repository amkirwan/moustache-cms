require 'spec_helper'

class Simple < MoustacheCms::Mustache::CmsPage
end

describe MoustacheCms::Mustache::PageParts do
  include_context "mustache page setup"

  before(:each) do
    @snippet = FactoryGirl.create(:snippet, :name => "foobar", :site => site, :created_by => user, :updated_by => user, :filter_name => "markdown",:content => "snippet **{{page_title}}**" )
  end

  describe "it should define the ghost method calls" do
    specify { @cmsp.respond_to?(:editable_text_content).should be_true }
    specify { @cmsp.respond_to?(:page_part_content).should be_true }
    specify { @cmsp.respond_to?(:snippet_foobar).should be_true }
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

    it "should define a method for the call to snippet_(name)" do
      @cmsp.snippet_foobar
      @cmsp.class.attribute_method_generated?(:snippet_foobar).should be_true   
    end
  end
  
  describe "it should render the page_part with the correct filter" do
    it "should return the page part rendered as markdown" do
      if @cmsp.editable_text_content
        @cmsp.editable_text_content.should == "<p>define editable text method <strong>strong</strong></p>"    
      end
    end
    
    it "should return the page part rendered as textile" do
      @page.page_parts.last.filter_name = "textile"
      if @cmsp.editable_text_content
        @cmsp.editable_text_content.should == "<p>define editable text method <b>strong</b></p>"    
      end    
    end
    
    it "should render as HTML" do
      @page.page_parts.last.filter_name = "html"
      if @cmsp.editable_text_content
        @cmsp.editable_text_content.should == "define editable text method **strong**"    
      end
    end
  end

  describe "it should render the snippet with the correct filter" do
    it "should return the snippet rendered with markdown" do
      @cmsp.snippet_foobar
      @cmsp.snippet_foobar.should == "<p>snippet <strong>foobar</strong></p>"
    end

    it "should return the snippet with textile" do
      @snippet.filter_name = "textile"
      @snippet.save
      @cmsp.snippet_foobar
      @cmsp.snippet_foobar.should == "<p>snippet <b>foobar</b></p>"
    end

    it "should render the snippet as HTML" do
      @snippet.filter_name = "html"  
      @snippet.save
      @cmsp.snippet_foobar
      @cmsp.snippet_foobar.should == "snippet **foobar**"
    end
  end
  
end
