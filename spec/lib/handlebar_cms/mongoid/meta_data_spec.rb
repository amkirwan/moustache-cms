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


  it "should have the method meta_data" do
    @dummy_class.should respond_to(:meta_data)
  end

  it "should have the key title in meta_data" do
    @dummy_class.meta_data.should have_key("title")
  end

  it "should have the key keywords in meta_data" do
    @dummy_class.meta_data.should have_key("keywords")
  end 
  
  # -- Callbacks ----
  describe "Callbacks" do
    before(:each) do
      @dummy_class.meta_data["DC.title"] = "foobar"
      @dummy_class.save
    end

    describe "#convert_period" do
      it "should convert '.' to '\\U+002E'" do
        @dummy_class.meta_data.should have_key("DC\\U+002Etitle")
      end

      it "should covert '\\U+002E' to '.'" do
        other_class = DummyClass.new(:meta_data => { "DC\\U+002Etitle" => "foobar" })
        other_class.meta_data.should have_key("DC.title")
      end
    end
  end
end
 
