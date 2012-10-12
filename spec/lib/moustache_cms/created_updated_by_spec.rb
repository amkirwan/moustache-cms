require 'spec_helper'

describe MoustacheCms::CreatedUpdatedBy do
  let(:site) { FactoryGirl.create(:site) }
  let(:asset_folder) { 'collectable_dummy' }

  class CreatedUpdatedByDummy < BaseCollection::Metal
    created_updated(:base_assets)
  end

  before(:each) do
    @dummy_class = CreatedUpdatedByDummy.new
  end

  describe "validations" do
    subject { @dummy_class }
    it { should validate_presence_of(:created_by_id) }
    it { should validate_presence_of(:updated_by_id) }
  end

  describe "associations" do
    subject { @dummy_class }
    it { should belong_to(:created_by).as_inverse_of(:base_assets_created) }  
    it { should belong_to(:updated_by).as_inverse_of(:base_assets_updated) }  
  end
 
end
