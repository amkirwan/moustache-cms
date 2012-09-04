require 'haml'

class MoustacheCms::Mustache::CmsPage < Mustache

  include AttributeMethods
  include Head
  include Navigation
  include MediaTags
  include PageParts
  include ArticleTags
  include CustomTags
  
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

  protected 
  def parse_text(text)
    Hash[*text.scan(/(\w+):([&.\w\s\-]+)/).to_a.flatten]
  end


  def action_view_helpers_context
    @action_view_context ||= Class.new do
      include Singleton
      include ActionView::Helpers
    end
    @action_view_context.instance
  end

  def action_view_context(template)
    context = ActionView::Base.new(template, {}, @controller, nil)
    context.class_eval do
      include Rails.application.routes.url_helpers
    end
    context
  end

  def controller_ivars_set
    variables = @controller.instance_variable_names
    variables.each do |var_name|
      self.instance_variable_set(var_name, @controller.instance_variable_get(var_name))
    end
  end  

 
  def process_with_filter(part)
    preprocessed_content = preprocess(part) 

    case part.filter_name
    when "markdown"
      process_with_markdown(preprocessed_content)
    when "textile"
      process_with_textile(preprocessed_content)
    when "html"
      preprocessed_content  
    else
      preprocessed_content  
    end
  end    

  def remove_empty_paragraph_tags(content)
    content.gsub(/<p><\/p>/, '')
  end

  def markdown
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :no_intra_emphasis => true, :space_after_headers => true) 
  end

  def process_with_markdown(content)
    markdown.render(content)
  end

  def process_with_textile(content)
    RedCloth.new(preprocessed_content).to_html
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

  def params
    @controller.params
  end
  #-- END protected 
end
