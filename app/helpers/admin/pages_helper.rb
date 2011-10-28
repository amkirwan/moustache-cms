module Admin::PagesHelper  

  def page_is_sortable?(mongoid_tree_item)
    unless mongoid_tree_item.root?
      content_tag :em, "", :class => 'sortable_list'
    end
  end


  def can_destroy_mongoid_tree_item?(mongoid_tree_item)
    if (can? :destroy, mongoid_tree_item) && !mongoid_tree_item.root?
      link_to( image_tag('delete_button.png', :class => "delete_image"), admin_page_path(mongoid_tree_item), :method => :delete, :confirm => "Are you sure you want to delete the page #{mongoid_tree_item.title}", :class => "delete", :remote => true) 
    end
  end


  def mongoid_tree_ul(mongoid_tree_set, init=true)
    if mongoid_tree_set.first.parent.nil?
      content_tag :ul, :class => 'pages' do
        render :partial => 'admin/pages/mongoid_tree_item', :collection => mongoid_tree_set, :locals => { :init => init}
      end
    else
      content_tag :ul, :class => 'sortable pages', :data_url => sort_admin_page_path(mongoid_tree_set.first.parent) do
        render :partial => 'admin/pages/mongoid_tree_item', :collection => mongoid_tree_set, :locals => { :init => init}
      end
    end
  end

  def mongoid_tree_item_id(mongoid_tree_item)
    mongoid_tree_item.title + '_' + mongoid_tree_item.id.to_s
  end

  def skip_children_on_initialize?(mongoid_tree_item, init)
    mongoid_tree_item.parent_id && init
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
      link_to "Delete", [:admin, page, meta_tag], :confirm => "Are you sure you want to delete the meta tag #{meta_tag.name}", :method => :delete, :class => "delete", :remote => true
    end
  end

  def meta_tag_id(meta_tag) 
    id = "meta_tag_" + meta_tag.name.gsub('.', '_').downcase
  end

  def page_form_id
    if @page.new_record?
      'new_page'
    else
      'edit_page_' + @page.title.downcase
    end
  end

end
