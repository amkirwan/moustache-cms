require 'spec_helper'

describe ThemeCollection do
  let(:site) { FactoryGirl.create(:site) }

  before(:each) do
    @theme_collection = FactoryGirl.create(:theme_collection, :site => site) 
  end

  # -- Associations ---
  describe "associations" do
    it "should belong to a site" do
      @theme_collection.should belong_to(:site)
    end

    it "should belong to a created_by" do
      @theme_collection.should belong_to(:created_by).of_type(User) 
    end

    it "should belong to updated_by" do
      @theme_collection.should belong_to(:updated_by).of_type(User)
    end

    it "should embed many theme_assets" do
      @theme_collection.should embed_many(:theme_assets)
    end
  end

  # -- Validations ---
  describe "Validations" do
    it "should be a valid theme collection" do
      @theme_collection.should be_valid
    end       

    it "should not be valid without a name" do
      @theme_collection.name = nil
      @theme_collection.should_not be_valid
    end

    it "should not be valid without a site_id" do
      @theme_collection.site_id = nil
      @theme_collection.should_not be_valid
    end

    it "should not be valid without created_by_id" do
      @theme_collection.created_by_id = nil
      @theme_collection.should_not be_valid   
    end

    it "should not be valid without updated_bY_id" do
      @theme_collection.updated_by_id = nil
      @theme_collection.should_not be_valid
    end
  end
end
