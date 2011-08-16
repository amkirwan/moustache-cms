module ApplicationHelper  
  def admin?     
    @current_user.role?("admin") ? true : false
  end
  
  def tree_ul(mongoid_tree_set, init=true, &block)
    if mongoid_tree_set.size > 0
      ret = '<ul id="pages">'
      mongoid_tree_set.each do |item|
        next if item.parent_id && init
        if item.root?
          ret += '<li id="home_page">'
        else
          ret += "<li id=\"#{item.title}\">"
        end
        ret += '<strong>'
        ret += yield item
        ret += '</strong>'
        ret += '<div class="page-info">'
        ret += '<em>'
        ret += item.updated_at.strftime("updated at %B %d %H:%M by #{item.updated_by.puid}")
        ret += '</em>'
        if can? :destroy, item
          ret += link_to( image_tag('delete_button.png'), admin_page_path(item), :method => :delete, :confirm => "Are you sure you want to delete the page #{item.title}", :class => "delete") if can? :destroy, item
        end
        ret += '</div>'
        ret += tree_ul(item.children, false, &block) if item.children.size > 0
        ret += '</li>'
      end
      ret += '</ul>'
      ret.html_safe
    end
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

  def li_current_page(path, selected_controller_name, &block)
    if controller.controller_name == selected_controller_name.to_s
      capture_haml do 
        haml_tag 'li.selected' do 
          yield path
        end
      end
    else
      capture_haml do 
        haml_tag 'li' do
          yield path
        end
      end
    end
  end
  
  def hash_to_open_struct(hash)
    OpenStruct.new(hash)
  end
  
  def filter_select(builder)
    builder.object.filter ? builder.object.filter.name : nil
  end
end
