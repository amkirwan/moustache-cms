After('@upload') do
    FileUtils.rm_rf(File.join(Rails.root, 'public', 'theme_assets', @site.id.to_s))
    FileUtils.rm_rf(File.join(Rails.root, 'public', 'authors', @site.id.to_s))
    FileUtils.rm_rf(File.join(Rails.root, 'public', 'site_assets', @site.id.to_s))

end 
