if Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.store_dir = "spec/tmp/uploads"
    config.cache_dir = "spec/tmp/cache"
    config.root = File.join(Rails.root, 'spec', 'tmp')
  end
end