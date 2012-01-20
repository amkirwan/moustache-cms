require 'haml'

class TagHelper
  include Singleton
  include ActionView::Helpers

  def page_full_path_with_request(request, page)
    "#{request.protocol}#{request.host.downcase}" + page.full_path
  end
end

class RedcarpetSingleton
  include Singleton

  def self.markdown
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML,:autolink => true, :space_after_headers => true) 
  end

end

class HandlebarCms::Mustache::CmsPage < Mustache
  include Head
  include Navigation
  include SiteCustomTags
  
  def initialize(controller)
    @controller = controller
    controller_ivars_set
  end
  
  def template
    if @page.class == Page
      @page.layout.content
    elsif @page.class == Article
      if @page.layout.nil?
        @page.article_collection.layout.content
      else
        @page.layout.content
      end
    else
      @page.layout.content
    end
  end
  
  def yield
    part = @page.page_parts.first
    process_with_filter(part)
  end

  def respond_to?(method)
    if method.to_s =~ /^editable_text_(.*)/ && @page.page_parts.find_by_name($1)
      true     
    elsif method.to_s =~ /^page_part_(.*)/ && @page.page_parts.find_by_name($1)
      true
    elsif method.to_s =~ /^snippet_(.*)/ && @current_site.snippet_by_name($1)
      true
    elsif method.to_s =~ /^meta_tag_(.*)/ 
      true
    elsif method.to_s =~ /^nav_children_(.*)/ && @current_site.page_by_title($1)
      true
    elsif method.to_s =~ /^nav_siblings_and_self_(.*)/ && @current_site.page_by_title($1)
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
    elsif name.to_s =~ /^meta_tag_(.*)/
      meta_tag_with_name($1)
    elsif name.to_s =~ /^nav_children_(.*)/
      nav_children($1)
    elsif name.to_s =~ /^nav_siblings_and_self_(.*)/
      nav_siblings_and_self($1)
    else
      super
    end    
  end

  def editable_text
    lambda do |text|
      part = @page.page_parts.find_by_name(text)
      process_with_filter(part)
    end
  end

  alias_method :page_part, :editable_text

  def snippet
    lambda do |text|
      process_with_filter(@current_site.snippet_by_name(text)) 
    end
  end

  def image
    lambda do |text|
      hash = Hash[*text.scan(/(\w+):([&.\w\s\-]+)/).to_a.flatten]
      image = @current_site.site_asset_by_name(hash['collection_name'], hash['name'])
      unless image.nil?
        engine = gen_haml('image')
        engine.render(nil, {:src => image.url_md5, :id => hash['id'], :class_name => hash['class'], :alt => hash['alt'], :title => hash['title']})
      end
    end
  end
  
  private 
    def controller_ivars_set
      variables = @controller.instance_variable_names
      variables.each do |var_name|
        self.instance_variable_set(var_name, @controller.instance_variable_get(var_name))
      end
    end  

    def editable_text_with_name(part_name)
      part = @page.page_parts.find_by_name(part_name)
      process_with_filter(part)
    end
    
    def snippet_with_name(name)        
      process_with_filter(@current_site.snippet_by_name(name)) 
    end
    
    def process_with_filter(part)
      preprocessed_content = preprocess(part)

      case part.filter_name
      when "markdown"
        markdown = RedcarpetSingleton.markdown
        markdown.render(preprocessed_content)
      when "textile"
        RedCloth.new(preprocessed_content).to_html
      when "html"
        preprocessed_content  
      when "haml"
        gen_haml(part.content).render(Object.new, {:current_site => @current_site, :request => @request, :page => @page })
      else
        preprocessed_content  
      end
    end    
    
    def gen_haml(template_name)
      template = File.read("#{File.dirname(__FILE__)}/templates/#{template_name}.haml")
      Haml::Engine.new(template, :attr_wrapper => "\"")
    end

    def preprocess(part)
      render part.content
    end
end
