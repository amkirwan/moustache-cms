require "carrierwave/test/matchers"

describe MediaAssetUploader do
  include CarrierWave::Test::Matchers
  
  let(:media_file) { MediaFile.new(:name => "foobar") }
  
  before do
    MediaAssetUploader.enable_processing = true
    @uploader = MediaAssetUploader.new(media_file, :media_asset)
    @uploader.store!(File.open("#{Rails.root}/public/images/rails.png"))
  end
  
  after do
    #@uploader.remove!
    MediaAssetUploader.enable_processing = false
  end
  
  it "should change the uploaded filename to the name of the media_file" do
    @uploader.filename.should == "foobar.png"
  end
  
  it "should white list these extenstiosn" do
    @uploader.extension_white_list.should == %w(jpg jpeg gif png pdf)
  end
end