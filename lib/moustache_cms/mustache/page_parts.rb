module MoustacheCms
  module Mustache
    module PageParts

      def editable_text
        lambda do |text|
          part = @page.page_parts.find_by_name(text)
          process_with_filter(part) unless part.nil?
        end
      end
      alias_method :page_part, :editable_text

      def snippet
        lambda do |text|
          process_with_filter(@current_site.snippet_by_name(text)) 
        end
      end

      def editable_text_with_name(part_name)
        part = @page.page_parts.find_by_name(part_name)
        process_with_filter(part)
      end
      
      def snippet_with_name(name)        
        process_with_filter(@current_site.snippet_by_name(name)) 
      end

      def respond_to?(method)
        if method.to_s =~ /^editable_text_(.*)/ && @page.page_parts.find_by_name($1)
          true     
        elsif method.to_s =~ /^page_part_(.*)/ && @page.page_parts.find_by_name($1)
          true
        elsif method.to_s =~ /^snippet_(.*)/ && @current_site.snippet_by_name($1)
          true
        else
          super
        end
      end

      def method_missing(name, *args, &block)
        if name.to_s =~ /^editable_text_(.*)/
          editable_text_with_name($1)   
        elsif name.to_s =~ /^page_part_(.*)/
          editable_text_with_name($1)
        elsif name.to_s =~ /^snippet_(.*)/
          snippet_with_name($1)
        else
          super
        end    
      end

    end
  end
end
