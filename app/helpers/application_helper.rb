module ApplicationHelper  
  
  def admin?     
    @current_user.role?("admin") ? true : false
  end
  
 
  def body_id_set
    name = controller.controller_name
    case name
    when "pages"
      name  
    when "site_assets", "asset_collections"
      "site_assets"
    when "snippets"
      name  
    when "layouts"
      name
    when "theme_assets"
      name
    when "users"
      name
    when "sites"
      name 
    end
  end    

  def hash_to_open_struct(hash)
    OpenStruct.new(hash)
  end
  
  def filter_select(builder)
    builder.object.filter ? builder.object.filter.name : nil
  end
  
  def header_content(partial_name, options={}, &block)
    if options[:object].class == Mongoid::Criteria
      options.merge!(:body => capture(&block), :title => options[:object].first.class.name.underscore.titleize)
    else
      options.merge!(:body => capture(&block), :name => name_or_title(options[:object]), :title => options[:object].class.name.underscore.titleize)
    end
    concat(render(:partial => partial_name, :locals => options))
  end

  def inner_content(partial_name, &block)
    options = { :body => capture(&block) }
    concat(render(:partial => partial_name, :locals => options))
  end

  def name_or_title(object)
    object.respond_to?(:title) ? object.title : object.name
  end

  def can_destroy?(object)
    class_name = object.class.name
    render :partial => "shared/header_button", :locals => { :object => object, :class_name => class_name.underscore, :title => class_name.underscore.titleize }
  end
  
end
