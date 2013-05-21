module MoustacheCms
  module Mustache
    module PageTags

      def title_tag
        engine = Haml::Engine.new(%{%title= title})
        engine.render(nil, {title: @page.title})
      end

      def page_title
        return @article.title unless @article.nil?
        @page.title
      end
      alias_method :article_title, :page_title

      def page_part
        lambda do |text|
          page_part_method(text)
        end
      end
      alias_method :editable_text, :page_part

      def respond_to?(method)
        method_name = method.to_s
        if method_name =~ /^page_part_(.*)indent_(.*)/ && @page.page_parts.find_by_name(remove_trailing_underscore($1))
          return true
        elsif method_name =~ /^editable_text_(.*)/ && @page.page_parts.find_by_name($1)
          return true
        elsif method_name =~ /^page_part_(.*)/ && @page.page_parts.find_by_name($1)
          return true
        else 
          super
        end
      end

      def method_missing(method, *args, &block)
        method_name = method.to_s
        if method_name =~ /^page_part_(.*)indent_(.*)/
          self.class.define_page_part_indent_method(method_name, remove_trailing_underscore($1), $2)
        elsif method_name =~ /^editable_text_(.*)/ || method_name =~ /^page_part_(.*)/
          self.class.define_page_part_method(method_name, $1)
        end

        if self.class.attribute_method_generated?(method)
          self.send(method)
        else
          super
        end
      end

      private
      
      def page_part_method(name, indentation=0)
        indentation = indentation.to_i
        @page_part = @page.page_parts.find_by_name(name)
        unless @page_part.nil?
          processed_part = process_with_filter(@page_part).chomp 
          if indentation > 0 
            rendered_text = processed_part.gsub(/^/, ' '*indentation + ' '*2)
            ":preserve\n" + rendered_text
          else
            processed_part
          end
        end
      end

      def remove_trailing_underscore(name)
        name.gsub(/_$/, '')  
      end

    end
  end
end
