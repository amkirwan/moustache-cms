require 'spec_helper'

describe Admin::CustomFieldsController do
  before(:each) do
    login_admin
    @page = mock_model("Page", :site_id => @site.id).as_null_object 
    @custom_field = mock_model(CustomField, :name => 'custom_field', :_parent => @page).as_null_object
    @custom_fields = [@custom_field]
    Page.stub(:find).and_return(@page)
  end

  #GET new
  describe "GET new" do
    before(:each) do
      @custom_field = mock_model(CustomField, :site_id => @site.id).as_new_record
      @page.stub(:custom_fields).and_return(@custom_fields)
      @custom_fields.stub(:new).and_return(@custom_field)
    end

    def do_get
      get :new, :page_id => @page.to_param
    end

    it "should assign the @page" do
      do_get
      assigns(:page).should == @page
    end

    it "should assign the @cutom_field" do
      do_get
      assigns(:custom_field).should == @custom_field
    end
  end

  #Delete destroy
  describe "DELETE destroy" do
    let(:params) { {:page_id => @page.id, :id => @custom_field.id} }

    before(:each) do
      @page.stub_chain(:custom_fields, :find).and_return(@custom_field)
      @custom_field.stub(:destroy).and_return(true)
      @custom_field.stub(:persisted?).and_return(false)
    end

    def do_delete(destroy_params=params)
      delete :destroy, destroy_params
    end

    context "with valid params" do
      it "should destroy the custom_field" do
        @custom_field.should_receive(:destroy).and_return(true)
        do_delete
      end

      it "should set the the flash notice message" do
        do_delete
        flash[:notice].should == "Successfully deleted the custom field #{@custom_field.name}"
      end
    end
  end

end
