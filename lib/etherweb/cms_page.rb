class Etherweb::CmsPage < Mustache
  
  def initialize(controller)
    @controller = controller
    assign_controller_ivars
    assign_template
  end
  
  def yield
    render @page.template
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
    def assign_controller_ivars
      variables = @controller.instance_variable_names
      variables.each do |var_name|
        self.instance_variable_set(var_name, @controller.instance_variable_get(var_name))
      end
    end  
    
    def assign_template
      self.template = @page.layout.content
    end
    
    def define_editable_text_method(name, part_name)
      self.class.send(:define_method, name) do  
        part = @page.page_parts.find_by_name(part_name)
        case part.filter["name"]
        when "markdown"
          Markdown.new(part.content).to_html
        when "textile"
          RedCloth.new(part.content).to_html
        when "html"
          RedCloth.new(part.content).to_html
        else
          part.content.to_s
        end
      end
    end
end