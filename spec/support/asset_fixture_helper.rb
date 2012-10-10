module AssetFixtureHelper
  def self.open(filename)
    File.new(File.join("#{Rails.root}", 'spec', 'fixtures', 'assets', filename))
  end

  def self.reset!
    FileUtils.rm_rf(File.join("#{Rails.root}", 'spec', 'tmp'))
    FileUtils.mkdir(File.join("#{Rails.root}", 'spec', 'tmp'))
  end

  def self.remove_asset!(asset)
    FileUtils.rm_rf(asset)
    self.reset!
  end
end
