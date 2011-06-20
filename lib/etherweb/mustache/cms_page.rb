class Etherweb::Mustache::CmsPage < Mustache
  include Head
  include Navigation
  
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
    elsif method.to_s =~ /^stylesheet_all$/
      true
    elsif method.to_s =~ /^stylesheet_(.*)/ && @current_site.css_files.find_by_name($1).first
      true
    elsif method.to_s =~ /^nav_children_and_self_(.*)/ && @current_site.page_by_name($1)
      true
    elsif method.to_s =~ /^nav_children_(.*)/ && @current_site.page_by_name($1)
      true
    elsif method.to_s =~ /^nav_siblings_and_self_(.*)/ && @current_site.page_by_name($1)
      true
    elsif method.to_s =~ /^nav_siblings_(.*)/ && @current_site.page_by_name($1)
      true
    elsif method.to_s =~ /^nav_child_pages_(.*)/
      true
    else
      super
    end
  end
  
  def method_missing(name, *args, &block)
    if name.to_s =~ /^editable_text_(.*)/
      editable_text($1)
    elsif name.to_s =~ /^stylesheet_(.*)/
      stylesheet($1)
    elsif name.to_s =~ /^nav_children_and_self_(.*)/
      nav_children_and_self($1)
    elsif name.to_s =~ /^nav_children_(.*)/
      nav_children($1)
    elsif name.to_s =~ /^nav_siblings_and_self_(.*)/
      nav_siblings_and_self($1)
    elsif name.to_s =~ /^nav_siblings_(.*)/
      nav_siblings($1)
    elsif name.to_s =~ /^nav_child_pages_(.*)/
      nav_child_pages($1)
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
    
    def editable_text(part_name)
      part = @page.page_parts.find_by_name(part_name)
      render page_part_filter(part)
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