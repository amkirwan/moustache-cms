module Etherweb
  module AssetCache
    def set_from_cache(opts={})
      if !opts[:cache_name].empty? && opts[:source].nil?
        opts[:asset].source.retrieve_from_cache!(opts[:cache_name])
        opts[:asset].source.store!
      end
    end
  end
end