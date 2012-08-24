module MoustacheCms
  module Mustache
    module PageParts

      def page_part
        lambda do |text|
          page_part_method(text)
        end
      end
      alias_method :editable_text, :page_part

      def snippet
        lambda do |text|
          snippet_method(text)
        end
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

      def method_missing(method_name, *args, &block)
        case method_name.to_s
        when /^editable_text_(.*)/
          #page_part.call($1)   
          self.class.define_page_part_method(method_name, $1)
        when /^page_part_(.*)/
          self.class.define_page_part_method(method_name, $1)
        when /^snippet_(.*)/
          self.class.define_snippet_method(method_name, $1)
        end

        if self.class.generated_methods.include?(method_name)
          self.send(method_name)
        else
          super
        end
      end

      private
      
      def snippet_method(name)
        snippet = @current_site.snippet_by_name(name)
        process_with_filter(snippet) unless snippet.nil?
      end

      def page_part_method(name)
        part = @page.page_parts.find_by_name(name)
        process_with_filter(part) unless part.nil?
      end

    end
  end
end
