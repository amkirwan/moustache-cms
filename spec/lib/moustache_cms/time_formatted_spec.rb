require 'spec_helper'

describe MoustacheCms::TimeFormatted do
  class TimeFormattedDummy
    include Mongoid::Document
    include MoustacheCms::StateSetable
  end

  before(:each) do
    @dummy_class = TimeFormattedDummy.new  
    @current_state = FactoryGirl.build(:current_state)
    @dummy_class.current_state = @current_state
  end

  describe "#status_formatted_date_time" do
    it "returns the abbreviated time zone" do
      @dummy_class.formatted_time_zone.should == @current_state.time.strftime("%Z").strip  
    end

    it "returns the humnanized formatted time" do
      @dummy_class.formatted_time.should == @current_state.time.strftime("%l%P").strip  
    end

    it "returns the humanized formatted date" do
      @dummy_class.formatted_date.should == @current_state.time.strftime("%e %b %Y").strip  
    end

    it "returns a humanized formatted date time of the current state" do
      @dummy_class.formatted_date_and_time_with_zone.should == @current_state.time.strftime("%e %b %Y at %l%P %Z").squeeze(" ").strip  
    end

    it "returns a humanized formatted date time of the current state with the time zone" do
      @dummy_class.formatted_date_and_time.should == @current_state.time.strftime("%e %b %Y at %l%P").squeeze(" ").strip  
    end
  end

    # describe "#status_formatted_date_time" do
    #   it "returns the formatted_date_time of the current state" do
    #     @article.formatted_date_time.should == "foobar"
    #   end
    # end

    # describe "#status_formatted_date_time_with_zone" do
    #   it "returns the formatted_date_time_with_zone of the current state" do
    #     @article.formatted_date_time_with_zone.should == @article.current_state.formatted_date_time_with_zone
    #   end
    # end

    # describe "#status_formatted_date" do
    #   it "returns the formatted_date for the current state" do
    #     @article.formatted_date.should == @article.current_state.formatted_date
    #   end  
    # end

    # describe "#status_formatted_time" do
    #   it "returns the formatted_time of the current state" do
    #     @article.formatted_time.should == @article.current_state.formatted_time  
    #   end
    # end

    # describe "#status_formatted_time_zone" do
    #   it "returns the formatted_time with zone for the current state" do
    #     @article.formatted_time_zone.should == @article.current_state.formatted_time_zone
    #   end
    # end

 
end
