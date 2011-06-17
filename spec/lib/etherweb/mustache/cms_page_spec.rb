require "spec_helper"

describe Etherweb::Mustache::CmsPage do
  let(:site) { Factory(:site)}
  let(:user) { Factory(:user, :site => site) }
  let(:layout) { Factory(:layout, :site => site, :created_by => user, :updated_by => user) }

  before(:each) do
    @controller = CmsSiteController.new
    @page = Factory(:page, :name => "foobar", :site => site, :created_by => user, :updated_by => user)
    @page.page_parts << Factory.build(:page_part, 
                                      :name => "content", 
                                      :content => "define_editable_text_method **strong**", 
                                      :filter => Filter.find_by_name(:markdown))
    @page.meta_data["title"] = %(name="title" content="foobar")
    @page.meta_data["keywords"] = %(name="keywords" content="foobar, keywords")
    @page.meta_data["description"] =  %(name = "description" "foobar description") 
    
    @theme_asset_css = Factory(:theme_asset, :site => site, :name => "foobar", :asset => AssetFixtureHelper.open("theme_css.css"), :content_type => "text/css")
    
    @request = mock_model("Request", :host => "test.com")
    
    @controller.instance_variable_set(:@page, @page)
    @controller.instance_variable_set(:@request, @request)
    @controller.instance_variable_set(:@current_site, site)
    @cmsp = Etherweb::Mustache::CmsPage.new(@controller)
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
        @cmsp.editable_text_content.should == "define_editable_text_method **strong**"    
      end
    end
  end 
  
  describe "head" do  
    it "should return the page title" do
      @cmsp.title.should == %{<title>#{@page.title}</title>\n}
    end  
    
    it "should return all the css files" do
      @cmsp.stylesheet_all.should == %(<link rel="stylesheet" href="#{@theme_asset_css.asset.url}">\n)
    end
    
    it "should return a stylesheet by name" do
      @cmsp.stylesheet_foobar.should == %(<link rel="stylesheet" href="#{@theme_asset_css.asset.url}">\n)
    end
    
    it "should return the meta title" do
      @cmsp.meta_title.should == %(<meta #{@page.meta_data["title"]} />)
    end

    it "should return the meta keywords" do
      @cmsp.meta_keywords.should == %(<meta #{@page.meta_data["keywords"]} />)
    end

    it "should return the meta description" do
      @cmsp.meta_description.should == %(<meta #{@page.meta_data["description"]} />)
    end

    it "should set the meta fields for the page" do
      @cmsp.meta_data.should == %(<meta name="title" content="#{@page.meta_data["title"]}">\n<meta name="keywords" content="#{@page.meta_data["keywords"]}">\n<meta name="description" content="#{@page.meta_data["description"]}">\n)
    end
  end
  
  describe "navigaton" do 
    before(:each) do
      @page2 = Factory(:page, :name => "foobar2", :site => site, :parent => @page, :created_by => user, :updated_by => user)
      @page3 = Factory(:page, :name => "foobar3", :site => site, :parent => @page, :created_by => user, :updated_by => user)
    end
    
    after(:each) do
      Site.all.delete
    end

    it "should return an unordered list of the pages children elements for navigation" do 
      @cmsp.nav_children_foobar.should == %(<ul class="nav nav_foobar"><li><a href="http://test.com#{@page2.full_path}" id="#{@page2.title}" title="#{@page2.title}">#{@page2.title}</a></li><li><a href="http://test.com#{@page3.full_path}" id="#{@page3.title}" title="#{@page3.title}">#{@page3.title}</a></li></ul>)
    end
    
    it "should return an unordered list of the pages children elements for navigation" do
      @cmsp.nav_child_pages.should == %(<ul class="nav"><li><a href="http://test.com#{@page2.full_path}" id="#{@page2.title}" title="#{@page2.title}">#{@page2.title}</a></li><li><a href="http://test.com#{@page3.full_path}" id="#{@page3.title}" title="#{@page3.title}">#{@page3.title}</a></li></ul>)
    end

    it "should return an unordered list of the pages children elements with a classname of sidebar" do
      @cmsp.nav_child_pages_sidebar.should == %(<ul class="sidebar"><li><a href="http://test.com#{@page2.full_path}" id="#{@page2.title}" title="#{@page2.title}">#{@page2.title}</a></li><li><a href="http://test.com#{@page3.full_path}" id="#{@page3.title}" title="#{@page3.title}">#{@page3.title}</a></li></ul>)
    end
    
    it "should return an unordered list of the pages siblings and self for navigation" do
      @cmsp.nav_siblings_and_self_foobar2.should == %(<ul class="nav nav_foobar2"><li><a href="http://test.com#{@page2.full_path}" id="#{@page2.title}" title="#{@page2.title}">#{@page2.title}</a></li><li><a href="http://test.com#{@page3.full_path}" id="#{@page3.title}" title="#{@page3.title}">#{@page3.title}</a></li></ul>)
    end
    
    it "should return an unordered list of the pages siblings without self for navigation" do
      @cmsp.nav_siblings_foobar2.should == %(<ul class="nav nav_foobar2"><li><a href="http://test.com#{@page3.full_path}" id="#{@page3.title}" title="#{@page3.title}">#{@page3.title}</a></li></ul>)
    end
  end
end 