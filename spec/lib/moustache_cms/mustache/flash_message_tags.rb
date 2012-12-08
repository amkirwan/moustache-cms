require 'spec_helper'

class Simple < MoustacheCms::Mustache::CmsPage
end

describe MoustacheCms::Mustache::FlashMessageTags do
  include_context "mustache page setup"
  
  before(:each) do
    @page.page_parts << FactoryGirl.build(:page_part, 
                                      :name => "main_content", 
                                      :content => "{{{flash_notice}}}",
                                      :filter_name => "markdown") 
    @page.save
    @cmsp.controller.stub(:flash).and_return({notice: 'The flash notice'})
    @cmsp.instance_variable_set("@page", @page)
  end

  describe "flash_notice" do
    it "should return the flash_notice" do
      @cmsp.flash_notice.should == "<div id=\"flash_notice_wrapper\">\n  <p id=\"flash_notice\">The flash notice</p>\n</div>\n"
    end
  end

end
