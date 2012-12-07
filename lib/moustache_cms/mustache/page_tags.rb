module MoustacheCms
  module Mustache
    module PageTags

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
        method_name = method.to_s
        if method_name =~ /^editable_text_(.*)/ && @page.page_parts.find_by_name($1)
          return true
        elsif method_name =~ /^page_part_(.*)/ && @page.page_parts.find_by_name($1)
          return true
        elsif method_name =~ /^snippet_(.*)/ && @current_site.snippet_by_name($1)
          return true
        else
          super
        end
      end

      def method_missing(method, *args, &block)
        method_name = method.to_s
        if method_name =~ /^editable_text_(.*)/ || method_name =~ /^page_part_(.*)/
          self.class.define_page_part_method(method_name, $1)
        elsif method_name =~ /^snippet_(.*)/
          self.class.define_snippet_method(method_name, $1)
        end

        if self.class.attribute_method_generated?(method)
          self.send(method)
        else
          super
        end
      end

      private
      
      def snippet_method(name)
        snippet = @current_site.snippet_by_name(name)
        process_with_filter(snippet).chomp unless snippet.nil?
      end

      def page_part_method(name)
        part = @page.page_parts.find_by_name(name)
        process_with_filter(part).chomp unless part.nil?
      end

    end
  end
end
