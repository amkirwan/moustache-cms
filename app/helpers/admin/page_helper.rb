module Admin::PageHelper  

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
        if item.updated_by.nil?
          ret += item.updated_at.strftime("updated %B %d at %H:%M")
        else
          ret += item.updated_at.strftime("updated %B %d at %H:%M by #{item.updated_by.puid}")
        end
        ret += '</em>'
        if can? :destroy, item
          ret += link_to( image_tag('delete_button.png', :class => "delete_image"), admin_page_path(item), :method => :delete, :confirm => "Are you sure you want to delete the page #{item.title}", :class => "delete") if can? :destroy, item
        end
        ret += '</div>'
        ret += tree_ul(item.children, false, &block) if item.children.size > 0
        ret += '</li>'
      end
      ret += '</ul>'
      ret.html_safe
    end
  end
 
  def manage_meta_tag page, meta_tag 
    case meta_tag.name
    when "title", "keywords", "description"
    else
      render :partial => "admin/pages/editable_meta_tag", :locals => { :page => page, :meta_tag => meta_tag }
    end
  end
end
