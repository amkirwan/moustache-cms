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

  end

  def set_page_part_content(name=nil, &block) 
    @page.page_parts.where(:name => 'content').first.content = block.call
    @page.save
    @cmsp.instance_variable_set("@page", @page)
  end

  describe "image tags" do
    it "should render the image tag" do
      set_page_part_content do
        "{{#image}}collection_name:blog, name:rails{{/image}}"
      end
      @cmsp.page_part_content.should == %{<p><img src="#{@image.url_md5}" /></p>}
    end

    it "should render the image tag options title, id, class, alt" do
      set_page_part_content do
        "{{#image}}collection_name:blog, name:rails, alt:rails logo, id:rails logo image, title: rails logo, class:rails-image{{/image}}"
      end
      @cmsp.page_part_content.should == %{<p><img alt="rails logo" class="rails-image" id="rails logo image" src="#{@image.url_md5}" title="rails logo" /></p>}
    end

    it "should render the image src without the fingerprint" do
      set_page_part_content do
        "{{#image}}collection_name:blog, name:rails, alt:rails logo, class:rails-image, fingerprint:false{{/image}}"
      end
      @cmsp.page_part_content.should == %{<p><img alt="rails logo" class="rails-image" src="#{@image.url}" /></p>}
    end

    it "should render a theme asset image" do
      set_page_part_content do
        "{{#image}}theme_collection_name:foobar, name:image, alt:rails logo, class:rails-image{{/image}}"
      end
      @cmsp.page_part_content.should == %{<p><img alt="rails logo" class="rails-image" src="#{@theme_asset_image.url_md5}" /></p>}
    end

  end

end
