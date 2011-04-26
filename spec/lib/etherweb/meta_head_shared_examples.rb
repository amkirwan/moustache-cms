require "spec_helper"

shared_examples_for "MetaHead" do

  it "should set the meta_title when set for the page" do
    @cmsp.meta_title.should == %(<meta name="DC.title" lang="en" content="#{@page.meta_title}">)
  end  
  
  it "should set the meta_keywords when set for the page" do
    @cmsp.meta_keywords.should == %(<meta name="keywords" content="#{@page.meta_keywords}">)
  end
  
  it "should set the meta_description when set for the page" do
    @cmsp.meta_description.should == %(<meta name="description" content="#{@page.meta_description}")
  end

end