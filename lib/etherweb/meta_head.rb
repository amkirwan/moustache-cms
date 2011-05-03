module Etherweb
  module MetaHead
    
    def meta_data
      meta_data = ""
      @page.meta_data.each_pair do |k, v|
        meta_data += %(<meta name="#{k}" content="#{v}">\n)
      end
      meta_data
    end
    
  end
end