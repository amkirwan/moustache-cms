module ApplicationHelper  
  
  def mark_required(field_name)
    "#{field_name.to_s.titleize}<abbr title='required' class='required'>*</abbr>".html_safe  
  end

  def admin?     
    @current_admin_user.role?("admin") ? true : false
  end

  def superuser?
    @current_admin_user.role?('superuser') ? true : false
  end

  def current_user?(user)
    user == @current_admin_user
  end
  
  def body_id_set
    name = controller.controller_name
    case name
    when "pages"
      name  
    when "article_collections", "articles"
      "articles"
    when "authors"
      name
    when "site_assets", "asset_collections"
      "site_assets"
    when "snippets"
      name  
    when "layouts"
      name
    when "theme_collections", "theme_assets"
      "theme_assets"  
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
    options[:class_name] = nil if options[:class_name].nil?
    if options[:object].class == Symbol
      title = title_for_header(options)
      options.merge!(:body => capture(&block), :title => title)
    elsif options[:object].new_record?
      options.merge!(:body => "", :title => "Create A New #{object_class_to_title(options[:object])}")
    else
      title = title_for_header(options)
      options.merge!(:body => capture(&block), :title => "#{title} #{view_identifier(options[:object])}")
    end
    concat(render(:partial => partial_name, :locals => options))
  end

  def title_for_header(options)
    if options[:title]
      options[:title]
    elsif options[:object].class == Symbol
      options[:object].to_s.underscore.titleize.pluralize
    else
      object_class_to_title(options[:object])
    end
  end

  def object_class_to_title(object)
    object.class.name.underscore.titleize  
  end

  def inner_content(partial_name, &block)
    options = { :body => capture(&block) }
    concat(render(:partial => partial_name, :locals => options))
  end

  def view_identifier(object)
    if object.respond_to?(:full_name)
      object.full_name 
    elsif object.respond_to?(:title)
      object.title
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
          if options.include?(:collection)
            link_to options[:message], [:new, :admin, options[:collection], options[:link]]
          else
            link_to options[:message], [:new, :admin, options[:link]]
          end
        end
      end
    else
      render :partial => 'index_table'
    end
  end

  def foldable_fieldset(label, options={})
    options[:class].nil? ? options[:class] = 'foldable' : options[:class] = "#{options[:class]} foldable"
    if options[:id].nil? 
      content_tag :fieldset, :class => "#{options[:class]}" do 
        concat(content_tag :legend, "#{label}<span class='fold_arrow'></span>".html_safe)
        yield
      end
    else
      content_tag :fieldset, :id => "#{options[:id]}", :class => "#{options[:class]}" do 
        concat(content_tag :legend, "#{label}<span class='fold_arrow'></span>".html_safe)
        yield
      end
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

  def header_title(page_title)
    content_for(:title) { page_title }
  end

  def builder_hidden_attribute(builder, object)
    unless object.new_record?
      content_tag :li do
        builder.hidden_field :id
      end
    end
  end

end
