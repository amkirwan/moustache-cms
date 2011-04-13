class Etherweb::CmsPage < Mustache
  
  def initialize(controller)
    @controller = controller
    assign_controller_ivars
    assign_template
  end
  
  def yield
    render @page.template
  end
  
  def editable_text
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
    
    def method_missing(name, *args, &block)
      if name =~ /^editable_text_(.*)$/
        if @page.respond_to?($1)
          define_method(name) {
            Markdown.new(@page.page_parts.find_by_name($1)).to_html
          }
        else
          super
        end
      else
        super
      end
    end
end