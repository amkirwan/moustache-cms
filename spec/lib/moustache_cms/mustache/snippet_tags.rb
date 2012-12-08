require 'spec_helper'

class Simple < MoustacheCms::Mustache::CmsPage
end

describe MoustacheCms::Mustache::SnippetTags do
  include_context "mustache page setup"
  
  before(:each) do
    @snippet = FactoryGirl.create(:snippet, :name => "foobar", :site => site, :created_by => user, :updated_by => user, :filter_name => "markdown",:content => "snippet **{{page_title}}**" )

    @page.page_parts << FactoryGirl.build(:page_part, 
                                      :name => "render_snippet", 
                                      :content => "{{{ snippet_foobar }}}",
                                      :filter_name => "markdown") 

    @page.save
    @cmsp.instance_variable_set("@page", @page)
  end

  describe "it should define the ghost method calls" do
    specify { @cmsp.respond_to?(:snippet_foobar).should be_true }
  end

  describe "it should create methods from ghost method calls" do
    it "should define a method for the call to snippet_(name)" do
      @cmsp.snippet_foobar
      @cmsp.class.attribute_method_generated?(:snippet_foobar).should be_true   
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
