require 'spec_helper'

describe MoustacheCms::Siteable do
  let(:site) { FactoryGirl.create(:site) }  

  class SiteableDummy 
    include Mongoid::Document 
    include MoustacheCms::Siteable
  end

  before(:each) do
    @dummy_class = SiteableDummy.new
  end

  describe "validations" do
    subject { @dummy_class }
    it { should validate_presence_of(:site_id) }
  end

  describe "associations" do
    subject { @dummy_class }
    it { should belong_to(:site) }      
  end
end
