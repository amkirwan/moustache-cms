require "spec_helper"

class DummyClass
  include Mongoid::Document 
  include HandlebarCms::Mongoid::MetaData
end

describe HandlebarCms::Mongoid::MetaData do 
  before(:each) do
    @dummy_class = DummyClass.new
    @dummy_class.extend(HandlebarCms::Mongoid::MetaData)
  end


  it "should have the method default_meta_data" do
    @dummy_class.should respond_to(:default_meta_data)
  end

  it "should have the key title in default_meta_data" do
    @dummy_class.default_meta_data.should have_key("title")
  end

  it "should have the key keywords in default_meta_data" do
    @dummy_class.default_meta_data.should have_key("keywords")
  end 

  it "should have the key description in default_meta_data" do
    @dummy_class.default_meta_data.should have_key("description")
  end

  it "should have the method additional_meta_data" do
    @dummy_class.should respond_to(:additional_meta_data) 
  end

  it "should initialze additional_meta_data to an empty array" do
    @dummy_class.additional_meta_data.should == []
  end
end
 
