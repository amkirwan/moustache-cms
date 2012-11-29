require 'spec_helper'

class Simple < MoustacheCms::Mustache::CmsPage
end

describe MoustacheCms::Mustache::HeadTags do
  include_context "mustache page setup"

  before(:each) do
    @theme_collection = FactoryGirl.create(:theme_collection, :name => 'thorn', :site => site, :theme_assets => [@theme_asset_css, @theme_asset_css_2])

    @tag_attr_type = FactoryGirl.build(:custom_field, 'name' => 'type', 'content' => 'text/css')
    @tag_attr_media = FactoryGirl.build(:custom_field, 'name' => 'media', 'content' => 'screen')

    @theme_asset_css = FactoryGirl.build(:theme_asset, :name => "foobar", :asset => AssetFixtureHelper.open("theme_css.css"), :content_type => "text/css", :custom_fields => [@tag_attr_type])
    @theme_asset_css_2 = FactoryGirl.build(:theme_asset,:name => "baz", :asset => AssetFixtureHelper.open("theme_css.css"), :content_type => "text/css", :custom_fields => [@tag_attr_type, @tag_attr_media])
    @theme_asset_js = FactoryGirl.build(:theme_asset, :name => "jquery-1.7.2.min", :asset => AssetFixtureHelper.open("jquery-1.7.2.min.js"), :content_type => "text/javascript")


    @theme_collection.theme_assets << @theme_asset_css
    @theme_collection.theme_assets << @theme_asset_css_2
    @theme_collection.theme_assets << @theme_asset_js
    @theme_collection.save
  end

  after(:each) do
    site_remove_assets(site)
  end
 

describe "head tags" do  
    it "should return the page title" do
      @cmsp.title_tag.should == %{<title>#{@page.title}</title>\n}
    end  

    it "should return the javascript file" do
      @page.layout.content = "{{#js_file}}theme_name:thorn, name:jquery-1.7.2.min{{/js_file}}"  
      cms_page = MoustacheCms::Mustache::CmsPage.new(@controller)
      cms_page.render.should == %(<script src="#{@theme_asset_js.url_md5}"></script>\n)
    end
    
    it "should return all the css files" do
      @cmsp.stylesheets.should == %(<link href="#{@theme_asset_css.url_md5}" rel="stylesheet" type="text/css" />\n<link href="#{@theme_asset_css_2.url_md5}" media="screen" rel="stylesheet" type="text/css" />\n)
    end
    
    it "should return a stylesheet by name" do
      @page.layout.content = "{{#stylesheet}}theme_name:thorn, name:foobar, media:screen{{/stylesheet}}"
      cms_page = MoustacheCms::Mustache::CmsPage.new(@controller)
      cms_page.render.should == %(<link href="#{@theme_asset_css.url_md5}" media="screen" rel="stylesheet" type="text/css" />\n)
    end
  end 

  describe "meta tags" do
  
    it "should return the meta title from the page" do
      @cmsp.meta_tag_title.should == %(<meta content="title page" name="title" />\n)
    end

    it "should return the meta keywords from the page" do
      @cmsp.meta_tag_keywords.should == %(<meta content="keywords page" name="keywords" />\n)
    end

    it "should return the meta description from the page" do
      @cmsp.meta_tag_description.should == %(<meta content="description page" name="description" />\n)
    end

    it "should return the meta title from the site" do
      @page.meta_tags.where(:name => 'title').first.content = ""
      @cmsp.meta_tag_title.should == %(<meta content="title site" name="title" />\n)
    end

    it "should return the meta keywords from the site" do
      @page.meta_tags.where(:name => 'keywords').first.content = ""
      @cmsp.meta_tag_keywords.should == %(<meta content="keywords site" name="keywords" />\n)
    end

    it "should return the meta description from the site" do
      @page.meta_tags.where(:name => 'description').first.content = ""
      @cmsp.meta_tag_description.should == %(<meta content="description site" name="description" />\n)
    end

  end

end
