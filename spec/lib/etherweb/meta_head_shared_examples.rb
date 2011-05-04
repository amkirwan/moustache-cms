require "spec_helper"

shared_examples_for "MetaHead" do
  
  it "should return the meta title" do
    @cmsp.meta_title.should == %(<meta name="title" content="#{@page.meta_data["title"]}")
  end
  
  it "should return the meta keywords" do
    @cmsp.meta_keywords.should == %(<meta name="keywords" content="#{@page.meta_data["keywords"]}")
  end
  
  it "should return the meta description" do
    @cmsp.meta_description.should == %(<meta name="description" content="#{@page.meta_data["description"]}")
  end
  
  it "should set the meta fields for the page" do
    @cmsp.meta_data.should == %(<meta name="title" content="#{@page.meta_data["title"]}">\n<meta name="keywords" content="#{@page.meta_data["keywords"]}">\n<meta name="description" content="#{@page.meta_data["description"]}">\n)
  end

end