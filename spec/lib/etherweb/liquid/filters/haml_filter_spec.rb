require 'spec_helper'

describe "Etherweb::Liquid::Filters:HamlFilter" do
  
  it "should return Hello, World with 'World' strong enclosed in paragraph tag" do
    @template = Liquid::Template.parse("{{ '%p Hello\r\n  %strong World!' | hamlize }}")
    @template.render({}, :filters => [HamlFilter]).should == "<p>Hello, <strong>World!</strong></p>\n"
  end
  
end