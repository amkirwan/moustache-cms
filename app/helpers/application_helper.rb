module ApplicationHelper  
  
  def admin?     
    @current_user.role?("admin") ? true : false
  end
  
  def current_site
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
    if options[:object].class == Symbol
      options.merge!(:body => capture(&block), :title => options[:object].to_s.underscore.titleize.pluralize)
    elsif options[:object].new_record?
      options.merge!(:body => "", :title => "Create New #{options[:object].class.name.underscore.titleize}")
    else
      title = options[:show] == true ? "#{options[:object].class.name.underscore.titleize}" : "Editing #{options[:object].class.name.underscore.titleize}"
      options.merge!(:body => capture(&block), :title => "#{title} <b>#{view_identifier(options[:object]).titleize}</b>")
    end
    concat(render(:partial => partial_name, :locals => options))
  end

  def inner_content(partial_name, &block)
    options = { :body => capture(&block) }
    concat(render(:partial => partial_name, :locals => options))
  end

  def view_identifier(object)
    if object.respond_to?(:title)
      object.title
    elsif object.respond_to?(:full_name)
      object.full_name 
    else
      object.name
    end
  end

  def can_create?(object)
    class_name = object.name
    render :partial => "shared/header_button_new", :locals => { :object => object, :class_name => class_name.underscore, :title => class_name.underscore.titleize }
  end

  def can_destroy?(object)
    class_name = object.class.name
    parent = object._parent
    render :partial => "shared/header_button_delete", :locals => { :object => object, :parent => parent, :class_name => class_name.underscore, :title => class_name.underscore.titleize }
  end
  
  def list_objects(collection, options={})
    if collection.empty?
      content_tag :div, :class => 'add_some' do 
        content_tag :h4 do
          link_to options[:message], [:new, :admin, options[:link]]
        end
      end
    else
      render :partial => 'index_table'
    end
  end

  def foldable_fieldset(label)
    content_tag :fieldset, :class => 'foldable' do 
      concat(content_tag :legend, "#{label}<span class='fold_arrow rotate'></span>".html_safe)
      yield
    end
  end

  def record_object
    if @page
      @page
    elsif @site
      @site
    elsif @theme_asset
      @theme_asset
    end
  end
end
