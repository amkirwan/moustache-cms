require 'spec_helper'

describe MoustacheCms::Models::StateSetable do
  
  class StateSetableDummy
    include Mongoid::Document
    include MoustacheCms::Models::StateSetable
  end

  before(:each) do
    @dummy_class = StateSetableDummy.new
  end

  describe "associations" do
    subject { @dummy_class }

    it { should embed_one :current_state }
  end

  describe "validations" do
    subject { @dummy_class }

    it "should be valid with a current_state" do
      @dummy_class.current_state = FactoryGirl.build(:current_state)  
      @dummy_class.should be_valid
    end
    
    it { should validate_presence_of(:current_state) }

    it "should not be valid without a current_state" do
      @dummy_class.should_not be_valid  
    end

  end
end
