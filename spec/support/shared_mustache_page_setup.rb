shared_context "mustache page setup" do
  let(:site) { FactoryGirl.create(:site)}
  let(:user) { FactoryGirl.create(:user, :site => site) }
  let(:layout) { FactoryGirl.create(:layout, :site => site, :created_by => user, :updated_by => user) }

  before(:each) do
    @controller = CmsSiteController.new
    @page = FactoryGirl.create(:page, :title => "foobar", :site => site, :created_by => user, :updated_by => user)
    @page.page_parts << FactoryGirl.build(:page_part, 
                                      :name => "content", 
                                      :content => "define editable text method **strong**", 
                                      :filter_name => "markdown") 


    @request = mock_model("Request", :host => "test.com", :protocol => 'http', :xhr? => false).as_null_object
    @controller.instance_variable_set(:@page, @page)
    @controller.instance_variable_set(:@_request, @request)
    @controller.instance_variable_set(:@current_site, site)
    @cmsp = MoustacheCms::Mustache::CmsPage.new(@controller)
  end
end
