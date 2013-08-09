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
  end

  describe "included" do
    subject { @dummy_class }
    it { should embed_one :current_state }
    it { should validate_presence_of(:current_state) }
  end

  describe "time formatted methods" do
    method_prefix = %w(published_at_ created_at_ updated_at_)
    method_prefix.unshift('')

    it "should respond to the formatted date method" do
      method_prefix.each { |prefix| @dummy_class.should respond_to "#{prefix}formatted_date" }
    end

    it "should respond to the formatted time zone method" do
      method_prefix.each { |prefix| @dummy_class.should respond_to "#{prefix}formatted_time_zone" }
    end
    
    it "should respond to the formatted date and time method" do
      method_prefix.each { |prefix| @dummy_class.should respond_to "#{prefix}formatted_date_and_time" }
    end

    it "should respond to the formatted date and time with zone method" do
      method_prefix.each { |prefix| @dummy_class.should respond_to "#{prefix}formatted_date_and_time_with_zone" }
    end

    it "should respond to the datetime_date" do
      method_prefix.each { |prefix| @dummy_class.should respond_to "#{prefix}datetime_date" }
    end

    it "should respond to the datetime_iso8601" do
      method_prefix.each { |prefix| @dummy_class.should respond_to "#{prefix}datetime_iso8601" }
    end

    it "should respond to the full_day_name" do
      method_prefix.each { |prefix| @dummy_class.should respond_to "#{prefix}full_day_name" }
    end

    it "should respond to the abbv_day_name" do
      method_prefix.each { |prefix| @dummy_class.should respond_to "#{prefix}abbv_day_name" }
    end

    it "should respond to the full_month_name" do
      method_prefix.each { |prefix| @dummy_class.should respond_to "#{prefix}full_month_name" }
    end
    
    it "should respond to the abbv_month_name" do
      method_prefix.each { |prefix| @dummy_class.should respond_to "#{prefix}abbv_month_name" }
    end

    it "should respond to the year method" do
      method_prefix.each { |prefix| @dummy_class.should respond_to "#{prefix}year" }
    end

    it "should respond to the month method" do
      method_prefix.each { |prefix| @dummy_class.should respond_to "#{prefix}month" }
    end
    
    it "should respond to the day method" do
      method_prefix.each { |prefix| @dummy_class.should respond_to "#{prefix}day" }
    end

    it "should respond to the zone method" do
      method_prefix.each { |prefix| @dummy_class.should respond_to "#{prefix}zone" }
    end

  end
end
