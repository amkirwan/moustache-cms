module MoustacheCms
  module Mustache
    module SnippetTags

      def snippet
        lambda do |text|
          snippet_method(text)
        end
      end

      def respond_to?(method)
        method_name = method.to_s
        if method_name =~ /^snippet_(.*)/ && @current_site.snippet_by_name($1)
          return true
        else
          super
        end
      end

      def method_missing(method, *args, &block)
        method_name = method.to_s  
        if method_name =~ /^snippet_(.*)/
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
    end
  end
end

