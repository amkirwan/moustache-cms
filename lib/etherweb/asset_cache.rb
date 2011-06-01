module Etherweb
  module AssetCache
    def set_from_cache(opts={})
      if !opts[:cache_name].empty? && opts[:asset].nil?
        opts[:asset].asset.retrieve_from_cache!(opts[:cache_name])
        opts[:asset].asset.store!
      end
    end
  end
end