class Etherweb::Mustache::CmsPage < Mustache
  include MetaHead
  
  def initialize(controller)
    @controller = controller
    controller_ivars_set
  end
  
  def template
    @page.layout.content
  end
  
  def yield
    part = @page.page_parts.first
    render page_part_filter(part)
  end
  
  def respond_to?(method)
    if method.to_s =~ /^editable_text_(.*)/ && @page.page_parts.find_by_name($1)
      true
    else
      super
    end
  end
  
  def method_missing(name, *args, &block)
    if name.to_s =~ /^editable_text_(.*)/
      define_editable_text_method(name, $1)
    else
      super
    end    
  end
  
  private 
    def controller_ivars_set
      variables = @controller.instance_variable_names
      variables.each do |var_name|
        self.instance_variable_set(var_name, @controller.instance_variable_get(var_name))
      end
    end  
    
    def define_editable_text_method(name, part_name)
      self.class.send(:define_method, name) do  
        part = @page.page_parts.find_by_name(part_name)
        render page_part_filter(part)
      end
    end
    
    def page_part_filter(part)
      case part.filter["name"]
      when "markdown"
        Redcarpet.new(part.content).to_html
      when "textile"
        RedCloth.new(part.content).to_html
      when "html"
        part.content.to_s
      else
        part.content.to_s
      end
    end
end