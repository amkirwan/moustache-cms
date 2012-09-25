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

    @page.page_parts << FactoryGirl.build(:page_part, 
                                      :name => "main_content", 
                                      :content => "{{#image}}collection_name:blog, name:rails{{/image}}",
                                      :filter_name => "markdown") 

    @page.page_parts << FactoryGirl.build(:page_part, 
                                      :name => "alt", 
                                      :content => "{{#image}}collection_name:blog, name:rails, alt:rails logo{{/image}}",
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

    it "should render the image tag with an alt acnd class" do
      set_page_part_content 'main_content' do
        "{{#image}}collection_name:blog, name:rails, alt:rails logo, class:rails-image{{/image}}"
      end
      @cmsp.page_part_main_content.should == %{<p><img alt="rails logo" class="rails-image" src="#{@image.url_md5}" /></p>}
    end
  end

end

  

