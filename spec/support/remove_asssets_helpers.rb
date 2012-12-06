def remove_theme_assets
  FileUtils.rm_rf(File.join(Rails.root, 'public', 'theme_assets', @theme_collection.site_id.to_s))
end

def remove_author_assets
  FileUtils.rm_rf(File.join(Rails.root, 'public', 'authors', @author.site_id.to_s))
end

def remove_site_assets
  FileUtils.rm_rf(File.join(Rails.root, 'public', 'site_assets', @ac.site_id.to_s))
end

def site_remove_assets(site)
  FileUtils.rm_rf(File.join(Rails.root, 'public', 'theme_assets', site.id.to_s))
  FileUtils.rm_rf(File.join(Rails.root, 'public', 'authors', site.id.to_s))
  FileUtils.rm_rf(File.join(Rails.root, 'public', 'site_assets', site.id.to_s))
end
