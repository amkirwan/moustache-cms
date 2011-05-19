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
        ret += '<div class="page_last_update">'
        ret += '<em>'
        ret += item.updated_at.strftime("Last updated %B %d @ %H:%M by #{item.updated_by.puid}")
        ret += '</em>'
        ret += button_to "delete", admin_page_path(item), :method => :delete, :confirm => "Are you sure you want to delete the page #{item.title}" if can? :destroy, item
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
      "pages"
    when "layouts"
      "layouts"
    when "users"
      "settings"
    end
  end    
  
  def li_current_page(path, &block)
    if current_page?(path)
      capture_haml do 
        haml_tag 'li.selected' do 
          yield
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
    
end