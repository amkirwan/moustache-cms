require 'spec_helper'

describe MoustacheCms::TimeFormatted do
  class TimeDummyClass 
    include Mongoid::Document
    include Mongoid::Timestamps

    attr_accessor :current_state

  end

  before(:each) do
    @current_state = FactoryGirl.build(:current_state)
    @dummy_time_class = TimeDummyClass.create
    @dummy_time_class.current_state = @current_state
    @dummy_class = MoustacheCms::TimeFormatted.new(@dummy_time_class)
  end

  describe "respond_to?" do
    it "should respond to the following methods" do
      methods =  %w(formatted_date formatted_time formatted_time_zone formatted_date_and_time formatted_date_and_time_with_zone formatted_date_and_time datetime_date datetime_iso8601 full_weekday_name abbv_weekday_name full_month_name abbv_month_name year month day zone)
      methods.each do |m|
        @dummy_class.should respond_to m
        @dummy_class.should respond_to 'published_at_' + m
        @dummy_class.should respond_to 'created_at_' + m
        @dummy_class.should respond_to 'updated_at_' + m
      end
    end
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

    it "returns a humanized formatted date time of the current state with the time zone" do
      @dummy_class.formatted_date_and_time_with_zone.should == @current_state.time.strftime("%e %b %Y at %l%P %Z").squeeze(" ").strip  
    end

    it "returns a humanized formatted date time of the current state" do
      @dummy_class.formatted_date_and_time.should == @current_state.time.strftime("%e %b %Y at %l%P").squeeze(" ").strip  
    end
  end

  it "returns the iso860 date format" do
    @dummy_class.datetime_iso8601.should == @current_state.time.iso8601.to_s 
  end

  it "returns the datetime with just the date" do
    @dummy_class.datetime_date.should == @current_state.time.strftime("%Y-%m-%d")
  end

  it "returns the year of the current state as a string number" do
    @dummy_class.year.should == @current_state.time.strftime("%Y")
  end

  it "returns the month of the current state as a string day" do
    @dummy_class.month.should == @current_state.time.strftime("%m")
  end

  it "returns the day of the current state as a string day" do
    @dummy_class.day.should == @current_state.time.strftime("%d")
  end

  it "returns the time zone as a string" do
    @dummy_class.zone.should == @current_state.time.zone
  end
end
