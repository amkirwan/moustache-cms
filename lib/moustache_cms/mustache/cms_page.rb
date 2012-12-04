require 'haml'

class MoustacheCms::Mustache::CmsPage < Mustache

  include AttributeMethods
  include HeadTags
  include NavigationTags
  include MediaTags
  include PagePartTags
  include ArticleTags
  include CustomTags
  
  def initialize(controller)
    @controller = controller
    controller_ivars_set
  end
  
  def template
    if @article
      @template = @article.layout ? @article.layout.content : @article.article_collection.layout.content 
    else
      @template = @page.layout.content
    end
    @template
  end
  
  def yield
    part = @page.page_parts.first
    process_with_filter(part)
  end
  
  protected 
  def parse_text(text)
    Hash[*text.scan(/(\w+):([&.\w\s\-]+)/).to_a.flatten]
  end

  def full_request(relative_link)
    'http://' + @controller.request.host + relative_link
  end

  def action_view_helpers_context
    @action_view_context ||= Class.new do
      include Singleton
      include ActionView::Helpers
    end
    @action_view_context.instance
  end

  def action_view_context(template=nil)
    template = File.join("#{Rails.root}", 'lib', 'moustache_cms', 'mustache', 'templates') if template.nil?
    context = ActionView::Base.new(template, {}, @controller, nil)
    _controller = @controller
    context.class_eval do
      include Rails.application.routes.url_helpers
      include Rails.application.routes.mounted_helpers
      # hackish but can't seem to get helper_methods to working from views otherwise.
      _controller._helper_methods.each do |method_name|
        define_method(method_name) { @controller.send(method_name) } unless self.method_defined?(method_name)
      end
    end
    context
  end

  def templates_dir
    File.join("#{Rails.root}", 'lib', 'moustache_cms', 'mustache', 'templates') 
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
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, table: true, autolink: true, no_intra_emphasis: true, space_after_headers: true, strikethrough: true, fenced_code_blocks: true) 
  end

  def process_with_markdown(content)
    markdown.render(content)
  end

  def process_with_textile(content)
    RedCloth.new(content).to_html
  end

  def gen_haml(template_name)
    if File.exists?(File.expand_path("../templates/#{template_name}", __FILE__))
      template = File.read(File.expand_path("../templates/#{template_name}", __FILE__))
    elsif File.exists?(File.expand_path("../custom_templates/#{template_name}", __FILE__))
      template = File.read(File.expand_path("../custom_templates/#{template_name}", __FILE__))
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
