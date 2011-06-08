# _form asset_collections
require 'spec_helper'

describe "admin/asset_collections/_form.html.haml" do   
  
  include FormHelpers
    
  let(:asset_collection) { stub_model(AssetCollection ) }
  
  before(:each) do
    assign(:asset_collection, asset_collection)
  end                                                                                                        
  
  def do_render(label)
    render "admin/asset_collections/form", :asset_collection => asset_collection, :button_label => label
  end
  
  it "should render a shared error partial" do
    do_render("label")
    view.should render_template(:partial => "shared/error_messages", :locals => { :target => asset_collection })
  end                                             
  
  describe "when the asset_collection is NEW" do
    before(:each) do
      asset_collection.as_new_record
      do_render("Save Collection")                   
    end                                                                                           
    
    it "should render a text field to name the collection" do
      form_new(:action => admin_asset_collections_path) do |f|
        f.should have_selector("input", :type => "text", :name => "asset_collection[name]")
      end
    end                                                       
    
    it "should render a button to submit" do
      form_new(:action => admin_asset_collections_path) do |f|
        f.should have_selector("input", :type => "submit", :value => "Save Collection")
      end
    end    
  end  
  
  describe "when EDITING the asset collection " do   
    before(:each) do
      asset_collection.stub(:new_record? => false)
    end 
    
    it "should render a text field to update the collection name" do  
      asset_collection.stub(:name => "foobar")                                              
      do_render("Update Collection")
      form_update(:action => admin_asset_collection_path(asset_collection)) do |f|
        f.should have_selector("input", :type => "text", :name => "asset_collection[name]", :value => "foobar") 
      end
    end                                                                                                  
    
    it "should render a button to submit the updated" do
      do_render("Update Collection")
      form_update(:action => admin_asset_collection_path(asset_collection)) do |f|
        f.should have_selector("input", :type => "submit", :value => "Update Collection") 
      end
    end
  end
  
end