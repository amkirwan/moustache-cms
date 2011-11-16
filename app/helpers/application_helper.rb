module ApplicationHelper  
  
  def admin?     
    @current_admin_user.role?("admin") ? true : false
  end

  def superuser?
    @current_admin_user.role?('superuser') ? true : false
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
    when "current_site"
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
      if block_given?
        title = options[:show] == true ? "#{options[:object].class.name.underscore.titleize}" : "Editing #{options[:object].class.name.underscore.titleize}"
        options.merge!(:body => capture(&block), :title => "#{title} <b>#{view_identifier(options[:object]).titleize}</b>")
      end
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
    render :partial => "shared/header_button_new", :locals => { :object => object, :class_name => class_name.underscore, :title => class_name.underscore.titleize } if can? :create, object
  end

  def can_destroy?(object)
    class_name = object.class.name
    parent = object._parent
    render :partial => "shared/header_button_delete", :locals => { :object => object, :parent => parent, :class_name => class_name.underscore, :title => class_name.underscore.titleize } if can? :destroy, object
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

  def foldable_fieldset(label, options={})
    options[:class].nil? ? options[:class] = 'foldable' : options[:class] = "#{options[:class]} foldable"
    content_tag :fieldset, :id => "#{options[:id]}", :class => "#{options[:class]}" do 
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

  def title_for_page(controller)
    default = @current_site.name.titleize + ' - ' 
    if controller.action_name == 'index'
      default + ' ' + controller.controller_name.titleize
    elsif controller.action_name == 'new'
      default + ' ' + controller.controller_name.singularize.titleize + ' New'
    else
      action = " #{controller.action_name.titleize} "
      model = " #{controller.controller_name.singularize.titleize} "
      default = case controller.controller_name
      when 'asset_collections'
        default + model + @asset_collection.name.titleize + action
      when 'current_site'
        default + action
      when 'domain_names'
        default + model + action
      when 'layouts'
        default + model + @layout.name.titleize + action
      when 'meta_tags'
        default + model + @meta_tag.name.titleize + action
      when 'page_parts'
        default + model + @page_part.name.titleize + action
      when 'pages'
        default + model + @page.title.titleize + action
      when 'site_assets'
        default + model + @site_asset.name.titleize + action
      when 'snippets'
        default + model + @snippet.name.titleize + action
      when 'tag_attrs'
        default + model + @tag_attr.name.titleize + action
      when 'theme_assets'
        default + model + @theme_asset.name.titleize + action
      when 'users'
        default + model + @user.full_name.titleize + action
      else
        default
      end
    end
  end

end
