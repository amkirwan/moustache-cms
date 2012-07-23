module MoustacheCms
  module AssetCache
    def set_from_cache(opts={})
      opts[:asset].asset.retrieve_from_cache!(opts[:cache_name])
      opts[:asset].asset.store!
    end
  end
end