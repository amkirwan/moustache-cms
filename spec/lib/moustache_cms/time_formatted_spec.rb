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

  describe "humanized methods for" do
    meth_prefix = %w(published_at created_at updated_at)

    it "#formatted date" do
      @dummy_class.formatted_date.should == @dummy_class.instance_variable_get('@created_at').strftime("%e %b %Y").strip  
      meth_prefix.each do |pre| 
        @dummy_class.send(pre + '_' + 'formatted_date').should == @dummy_class.instance_variable_get("@#{pre}").strftime("%e %b %Y").strip
      end
    end

    it "#formatted time" do
      @dummy_class.formatted_time.should == @dummy_class.instance_variable_get('@created_at').strftime("%l%P").strip  
      meth_prefix.each do |pre| 
        @dummy_class.send(pre + '_' + 'formatted_time').should == @dummy_class.instance_variable_get("@#{pre}").strftime("%l%P").strip  
      end
    end

    it "#formatted_time_zone returns abbreviated zone" do
      @dummy_class.formatted_time_zone.should == @dummy_class.instance_variable_get('@created_at').strftime("%Z").strip  
      meth_prefix.each do |pre| 
        @dummy_class.send(pre + '_' + 'formatted_time_zone').should == @dummy_class.instance_variable_get("@#{pre}").strftime("%Z").strip  
      end
    end

    it "#formatted_date_and_time returns formatted date and time" do
      @dummy_class.formatted_date_and_time.should == @dummy_class.instance_variable_get('@created_at').strftime("%e %b %Y at %l%P").squeeze(" ").strip  

      meth_prefix.each do |pre| 
        @dummy_class.send(pre + '_' + 'formatted_date_and_time').should == @dummy_class.instance_variable_get("@#{pre}").strftime("%e %b %Y at %l%P").squeeze(" ").strip  
      end
    end

    it "returns a humanized formatted date time of the current state with the time zone" do
      @dummy_class.formatted_date_and_time_with_zone.should == @dummy_class.instance_variable_get('@created_at').strftime("%e %b %Y at %l%P %Z").squeeze(" ").strip  

      meth_prefix.each do |pre| 
        @dummy_class.send(pre + '_' + 'formatted_date_and_time_with_zone').should == @dummy_class.instance_variable_get("@#{pre}").strftime("%e %b %Y at %l%P %Z").squeeze(" ").strip
      end
    end

    it "returns the datetime with just the date" do
      @dummy_class.datetime_date.should == @dummy_class.instance_variable_get('@created_at').strftime("%Y-%m-%d")

      meth_prefix.each do |pre| 
        @dummy_class.send(pre + '_' + 'datetime_date').should == @dummy_class.instance_variable_get("@#{pre}").strftime("%Y-%m-%d")
      end
    end

    it "returns the iso860 date format" do
      @dummy_class.datetime_iso8601.should == @dummy_class.instance_variable_get('@created_at').iso8601.to_s 

      meth_prefix.each do |pre| 
        @dummy_class.send(pre + '_' + 'datetime_iso8601').should == @dummy_class.instance_variable_get("@#{pre}").iso8601.to_s
      end
    end

    it "returns the full day name" do
      @dummy_class.full_day_name.should == @dummy_class.instance_variable_get('@created_at').strftime('%A')

      meth_prefix.each do |pre| 
        @dummy_class.send(pre + '_' + 'full_day_name').should == @dummy_class.instance_variable_get("@#{pre}").strftime('%A')
      end
    end

    it "returns the abbv day name" do
      @dummy_class.abbv_day_name.should == @dummy_class.instance_variable_get('@created_at').strftime('%a')

      meth_prefix.each do |pre| 
        @dummy_class.send(pre + '_' + 'abbv_day_name').should == @dummy_class.instance_variable_get("@#{pre}").strftime('%a')
      end
    end

    it "returns the full month name" do
      @dummy_class.full_month_name.should == @dummy_class.instance_variable_get('@created_at').strftime('%B')

      meth_prefix.each do |pre| 
        @dummy_class.send(pre + '_' + 'full_month_name').should == @dummy_class.instance_variable_get("@#{pre}").strftime('%B')
      end
    end

    it "returns the full month name" do
      @dummy_class.full_month_name.should == @dummy_class.instance_variable_get('@created_at').strftime('%B')

      meth_prefix.each do |pre| 
        @dummy_class.send(pre + '_' + 'full_month_name').should == @dummy_class.instance_variable_get("@#{pre}").strftime('%B')
      end
    end

    it "returns the abbv month name" do
      @dummy_class.abbv_month_name.should == @dummy_class.instance_variable_get('@created_at').strftime('%b')

      meth_prefix.each do |pre| 
        @dummy_class.send(pre + '_' + 'abbv_month_name').should == @dummy_class.instance_variable_get("@#{pre}").strftime('%b')
      end
    end

    it "returns the year, ie 1973" do
      @dummy_class.year.should == @dummy_class.instance_variable_get('@created_at').strftime("%Y")

      meth_prefix.each do |pre| 
        @dummy_class.send(pre + '_' + 'year').should == @dummy_class.instance_variable_get("@#{pre}").strftime('%Y')
      end
    end

    it "returns the month 1-12 " do
      @dummy_class.month.should == @dummy_class.instance_variable_get('@created_at').strftime("%m")

      meth_prefix.each do |pre| 
        @dummy_class.send(pre + '_' + 'month').should == @dummy_class.instance_variable_get("@#{pre}").strftime('%m')
      end
    end

    it "returns the day, ie 01-31" do
      @dummy_class.day.should == @dummy_class.instance_variable_get('@created_at').strftime("%d")

      meth_prefix.each do |pre| 
        @dummy_class.send(pre + '_' + 'day').should == @dummy_class.instance_variable_get("@#{pre}").strftime('%d')
      end
    end

    it "returns the time zone as a string" do
      @dummy_class.zone.should == @dummy_class.instance_variable_get('@created_at').zone

      meth_prefix.each do |pre| 
        @dummy_class.send(pre + '_' + 'zone').should == @dummy_class.instance_variable_get("@#{pre}").zone
      end
    end

  end
end
