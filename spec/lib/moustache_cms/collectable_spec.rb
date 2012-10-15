require 'spec_helper'

describe MoustacheCms::Collectable do
  let(:site) { FactoryGirl.create(:site) }
  let(:asset_folder) { 'collectable_dummy' }

  class CollectableDummy < MoustacheCollection
    collectable(:moustache_assets)
  end

  before(:each) do
    @dummy_class = CollectableDummy.new(name: 'foobar')
    @dummy_class.site_id = site.id # cannot mass assign site_id
  end

  after do
    FileUtils.rm_rf(File.join(Rails.root, 'public', asset_folder))
  end

  describe "validations" do
    subject { @dummy_class }
    it { should embed_many(:moustache_assets) }
    it { should validate_associated(:moustache_assets) }
  end

  describe "#destroy_collection_folder" do
    it "should remove the collection folder" do
      FileUtils.mkdir_p(File.join(Rails.root, 'public', asset_folder, site.id.to_s, @dummy_class.name))  
      @dummy_class.destroy_collection_folder(asset_folder)
      File.exists?(File.join(Rails.root, 'public', asset_folder, site.id.to_s, @dummy_class.name)).should be_false
    end
  end
end
