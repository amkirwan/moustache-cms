require 'spec_helper'

class Simple < MoustacheCms::Mustache::CmsPage
end

describe MoustacheCms::Mustache::NavigationTags do
  include_context "mustache page setup"

  def read_file(file_name)
    File.read(File.expand_path("../templates/#{file_name}", __FILE__))
  end

  describe "navigaton" do 
    before(:each) do
      @page2 = FactoryGirl.create(:page, :title => "foobar2", :site => site, :parent => @page, :created_by => user, :updated_by => user)
      @page3 = FactoryGirl.create(:page, :title => "foobar3", :site => site, :parent => @page, :created_by => user, :updated_by => user)
    end
    
    after(:each) do
      Site.all.delete
    end

    it "should return the primary pages children" do
      template  = read_file('nav_primary.haml')
      rendered = Haml::Engine.new(template, :attr_wrapper => "\"").render(nil, {:page2 => @page2, :page3 => @page3, :parent_page => @page})
      @cmsp.nav_primary.should == rendered
    end

    it "should return an unordered list of the pages children elements for navigation" do
      template = read_file('nav_children.haml')
      rendered = Haml::Engine.new(template, :attr_wrapper => "\"").render(nil, {:page2 => @page2, :page3 => @page3, :parent_page => @page})
      @cmsp.nav_child_pages.should == rendered
    end

    it "should return an unordered list of the pages for the given page name" do
      template = read_file('nav_children.haml')
      rendered = Haml::Engine.new(template, :attr_wrapper => "\"").render(nil, {:page2 => @page2, :page3 => @page3, :parent_page => @page})
      @cmsp.nav_children_foobar.should == rendered
    end

    it "should return an unordered list of the pages siblings for navigation" do
      template = read_file('nav_siblings_and_self.haml')
      rendered = Haml::Engine.new(template, :attr_wrapper => "\"").render(nil, {:page2 => @page2, :page3 => @page3 })
      @cmsp.nav_siblings_and_self_foobar2.should == rendered
    end
  end

end
