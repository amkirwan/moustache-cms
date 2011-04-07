require 'spec_helper'

describe "Etherweb::Liquid::Filters:TextileFilter" do
  
  it "should return Hello, World with 'World' strong enclosed in paragraph tag" do
    @template = Liquid::Template.parse("{{ 'Hello, *World!*' | textilize }}")
    @template.render({}, :filters => [TextileFilter]).should == "<p>Hello, <strong>World!</strong></p>"
  end
  
end