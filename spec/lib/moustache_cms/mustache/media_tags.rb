require 'spec_helper'

class Simple < MoustacheCms::Mustache::CmsPage
end

describe MoustacheCms::Mustache::MediaTags do
  include_context "mustache page setup"

  before(:each) do
    @asset_collection = FactoryGirl.create(:asset_collection, :name => 'blog', :site => site)
    @image = FactoryGirl.build(:site_asset, :name => 'rails')
    @asset_collection.site_assets << @image
    @asset_collection.save

    @theme_collection = FactoryGirl.create(:theme_collection, :name => 'foobar', :site => site)
    @theme_collection.theme_assets << @theme_asset_image = FactoryGirl.build(:theme_asset, :name => "image", :asset => AssetFixtureHelper.open("rails.png"), :content_type => "image/png", :creator_id => user.id, :updator_id => user.id)
    @theme_collection.theme_assets << @theme_asset_css = FactoryGirl.build(:theme_asset, :name => "css",  :asset => AssetFixtureHelper.open("theme_css.css"), :content_type => "text/css", :creator_id => user.id, :updator_id => user.id)
    @theme_collection.theme_assets << @theme_asset_js = FactoryGirl.build(:theme_asset, :name => "js", :asset => AssetFixtureHelper.open("theme_js.js"), :creator_id => user.id, :updator_id => user.id, :content_type => 'text/javascript')
    @theme_collection.theme_assets << @theme_asset_type = FactoryGirl.build(:theme_asset, :name => "other", :asset => AssetFixtureHelper.open("Inconsolata.otf"), :content_type => "application/octet-stream", :creator_id => user.id, :updator_id => user.id)
    @theme_collection.save


    @page.page_parts << FactoryGirl.build(:page_part, 
                                      :name => "main_content", 
                                      :content => "{{#image}}collection_name:blog, name:rails{{/image}}",
                                      :filter_name => "markdown") 

    @page.page_parts << FactoryGirl.build(:page_part, 
                                      :name => "alt", 
                                      :content => "{{#image}}collection_name:blog, name:rails, alt:rails logo{{/image}}",
                                      :filter_name => "markdown") 

    @page.page_parts << FactoryGirl.build(:page_part, 
                                      :name => "foobar_image", 
                                      :content => "{{#image}}theme_collection_name:foobar, name:image, alt:theme image{{/image}}",
                                      :filter_name => "markdown") 
    @page.save
    @cmsp.instance_variable_set("@page", @page)
  end

  def set_page_part_content(name, &block) 
    @page.page_parts.where(:name => name).first.content = block.call
    @page.save
    @cmsp.instance_variable_set("@page", @page)
  end

  describe "image tags" do
    it "should render the image tag" do
      @cmsp.page_part_main_content.should == %{<p><img src="#{@image.url_md5}" /></p>}
    end

    it "should render the image tag with an alt option" do
      set_page_part_content 'main_content' do
        "{{#image}}collection_name:blog, name:rails, alt:rails logo{{/image}}"
      end
      @cmsp.page_part_main_content.should == %{<p><img alt="rails logo" src="#{@image.url_md5}" /></p>}
    end

    it "should render the image tag with an alt and class" do
      set_page_part_content 'main_content' do
        "{{#image}}collection_name:blog, name:rails, alt:rails logo, class:rails-image{{/image}}"
      end
      @cmsp.page_part_main_content.should == %{<p><img alt="rails logo" class="rails-image" src="#{@image.url_md5}" /></p>}
    end

    it "should render the the image src without the fingerprint" do
      set_page_part_content 'main_content' do
        "{{#image}}collection_name:blog, name:rails, alt:rails logo, class:rails-image, fingerprint:false{{/image}}"
      end
      @cmsp.page_part_main_content.should == %{<p><img alt="rails logo" class="rails-image" src="#{@image.asset.url}" /></p>}
    end

  end

end
