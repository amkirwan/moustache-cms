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
            ret += '<li id="root_node">'
          else
            ret += '<li>'
          end
          ret += '<strong>'
          ret += yield item
          ret += '</strong>'
          ret += '<div class="page_last_update">'
          ret += '<em>'
          ret += item.updated_at.strftime("Last updated at %B %d %H:%M")
          ret += '</em>'
          ret += '</div>'
          ret += tree_ul(item.children, false, &block) if item.children.size > 0
          ret += '</li>'
        end
        ret += '</ul>'
        ret.html_safe
      end
    end
end