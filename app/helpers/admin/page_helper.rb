module Admin::PageHelper  

  def mongoid_tree_ul(mongoid_tree_set, init=true)
    render :partial => 'admin/pages/mongoid_tree', :locals => { :mongoid_tree_set => mongoid_tree_set, :init => init }
  end

  def skip_children_on_initialize?(mongoid_tree_item, init)
    mongoid_tree_item.parent_id && init
  end

  def index_page_id(mongoid_tree_item)
    mongoid_tree_item.root? ? "home_page" : mongoid_tree_item.title    
  end

  def index_page_time(mongoid_tree_item)
    if mongoid_tree_item.updated_by.nil?
      "updated " + time_ago_in_words(mongoid_tree_item.updated_at) + " ago"
    else
      "updated " + time_ago_in_words(mongoid_tree_item.updated_at) + " ago by #{mongoid_tree_item.updated_by.puid}"
    end
  end

  def child_pages?(mongoid_tree_item)
    if mongoid_tree_item.children.size > 0
      mongoid_tree_ul(mongoid_tree_item.children, false)
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
