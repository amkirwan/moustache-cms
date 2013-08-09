require 'spec_helper'

describe MoustacheCms::StateSetable do
  class StateSetableDummy
    include Mongoid::Document
    include Mongoid::Timestamps
    include MoustacheCms::StateSetable
  end 

  before(:each) do
    @dummy_class = StateSetableDummy.new
    @dummy_class.current_state = FactoryGirl.build(:current_state)
    @dummy_class.save
  end

  describe "included" do
    subject { @dummy_class }
    it { should embed_one :current_state }
    it { should validate_presence_of(:current_state) }
  end

  describe "time formatted methods" do
    it "should respond to the time formatted method" do
      @dummy_class.should respond_to :formatted_date_and_time
    end

    it "should respond to the time formatted method with zone" do
      @dummy_class.should respond_to :formatted_date_and_time_with_zone
    end

    it "should respond to the formatted date method" do
      @dummy_class.should respond_to :formatted_date
    end
    
    it "should respond to the formatted time method" do
      @dummy_class.should respond_to :formatted_time
    end

    it "should respond to the formatted time zone method" do
      @dummy_class.should respond_to :formatted_time_zone
    end

  end
        
end
