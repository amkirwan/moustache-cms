require 'haml'
require 'tag_helper'
require 'redcarpet_singleton'

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
      unless part.nil?
        process_with_filter(part)
      end
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
        engine = gen_haml('image.haml')
        engine.render(nil, {:src => image.url_md5, :id => hash['id'], :class_name => hash['class'], :alt => hash['alt'], :title => hash['title']})
      end
    end
  end

  def page_paginate_children
    lambda do |text|
      @child_pages = @page.children.asc(:title).page(@controller.params[:page])
      unless @child_pages.nil?
        options = Hash[*text.scan(/(\w+).to_sym:([&.\w\s\-]+)/).to_a.flatten]
        context = ActionView::Base.new("#{Rails.root}/lib/handlebar_cms/mustache/custom_templates", {}, @controller,nil)
        engine = gen_haml('paginate.haml')
        engine.render(context, {:child_pages => @child_pages, :options => options})
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
      else
        preprocessed_content  
      end
    end    
    
    def gen_haml(template_name)
      if File.exists?("#{File.dirname(__FILE__)}/templates/#{template_name}")
        template = File.read("#{File.dirname(__FILE__)}/templates/#{template_name}")
      elsif File.exists?("#{File.dirname(__FILE__)}/custom_templates/#{template_name}")
        template = File.read("#{File.dirname(__FILE__)}/custom_templates/#{template_name}") 
      end
      Haml::Engine.new(template, :attr_wrapper => "\"")
    end

    def preprocess(part)
      render part.content
    end
end
