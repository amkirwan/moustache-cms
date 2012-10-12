require 'spec_helper'

describe BaseCollection do
  let(:site) { FactoryGirl.create(:site) }
  let(:user) { FactoryGirl.create(:user) }

  before(:each) do
    @base_collection = FactoryGirl.create(:base_collection)
  end

  # -- Associations --- 
  describe "associations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:site_id) }
  end
  
end
