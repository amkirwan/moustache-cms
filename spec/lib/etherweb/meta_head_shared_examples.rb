require "spec_helper"

shared_examples_for "MetaHead" do
  
  it "should set the meta fields for the page" do
    @cmsp.meta_data.should == %(<meta name="title" content="#{@page.meta_data["title"]}">\n<meta name="keywords" content="#{@page.meta_data["keywords"]}">\n<meta name="description" content="#{@page.meta_data["description"]}">\n)
  end

end