module Admin::PagesHelper  

  def page_is_sortable?(page)
    unless page.root?
      if page.published?
        content_tag :em, "", :class => 'sortable_list published'
      else
        content_tag :em, "", :class => 'sortable_list draft'
      end
    end
  end

  def can_add_child_page?(page)
    if can? :create, page
      link_to "<div class=\"add_child_page\">Add Page</div>".html_safe, new_admin_page_path(:parent_id => page.id), :class => "create"
    end
  end

  def can_destroy_page?(page)
    return if page.root?

    if can? :destroy, page 
      link_to "<div class=\"delete_page delete_#{page.title.parameterize('_')}\">Delete Page</div>".html_safe, admin_page_path(page), :method => :delete, :data => { :confirm => "Are you sure you want to delete the page #{page.title}?" }, 'data-title' => "#{page.title}", :class => "delete", :remote => true
    end
  end

  def render_pages(pages)
    return if pages.empty?

    if pages.first.root?
      content_tag :ol, :class => 'pages' do
        render pages
      end
    else
      content_tag :ol, :class => 'pages sortable', 'data-url' => sort_admin_page_path(pages.first.parent) do
        render pages
      end
    end
  end

  def page_id(page)
    page.title.parameterize('_') + '_' + page.id.to_s
  end

  def page_id_was
    @page_title_was.parameterize('_') + '_' + @page.id.to_s
  end

  def fold_arrow?(page)
    return if page.root?

    if page.children.size > 0
      link_to "<div></div>".html_safe, admin_page_path(page), :remote => true, :class => "page_fold_arrow"
    end
  end

  def child_pages
    "child_pages" unless @page.children.empty?
  end

  def page_classes(page)
    if page.published?
      page.home_page? ? 'home_page published' : 'published'
    elsif page.draft?
      page.home_page? ? 'home_page draft' : 'draft'
    end
  end

  def page_time_format(page)
    if page.updated_by.nil?
      "updated " + time_ago_in_words(page.updated_at) + " ago"
    else
      "updated " + time_ago_in_words(page.updated_at) + " ago by #{page.updated_by.username}"
    end
  end

  def render_child_pages(page)
    return unless page.root?

    render_pages page.children
  end

  def manage_meta_tag page, meta_tag 
    case meta_tag.name
    when "title", "keywords", "description"
    else
      link_to "Delete", [:admin, page, meta_tag], :data => { :confirm => "Are you sure you want to delete the meta tag #{meta_tag.name}" }, :method => :delete, :class => "delete", :remote => true
    end
  end

  def meta_tag_id(meta_tag) 
    id = "meta_tag_" + meta_tag.name.gsub('.', '_').downcase
  end

  def custom_field_id(custom_field)
    id = "custom_field_" + custom_field.name.gsub('.', '_').downcase
  end

  def page_form_id
    if @page.new_record?
      'new_page'
    else
      'edit_page_' + @page.title.parameterize('_')
    end
  end

 def add_page_part
    if @page.new_record?
      content_tag :p, content_tag(:i, "Save page first to add additonal page parts")
    else
      link_to 'Add Page Part', [:admin, @page, :page_parts], :method => :post, :remote => true
    end
  end

  def delete_page_part
    if @page.page_parts.size > 1  
      content = content_tag :span, '&#124; '.html_safe, :class => 'menu_separator'
      content += link_to "Delete", [:admin, @page, @selected_page_part], :method => :delete, :data => { :confirm => "Are you sure you want to delete the page part #{@selected_page_part.name}" }, :class => "delete", :remote => true
      content
    end
  end

  def page_part_selected(page_part)
    unless @page.new_record?
      if @selected_page_part.id == page_part.id
        content_tag :li, :id => "#{page_part.id}_nav", :class => 'tab selected' do
          link_to page_part.name, edit_admin_page_page_part_path(@page, page_part.id, :view => page_part.id), :remote => true
        end
      else
        content_tag :li, :id => "#{page_part.id}_nav", :class => 'tab' do
          link_to page_part.name, edit_admin_page_page_part_path(@page, page_part.id, :view => page_part.id), :remote => true
        end
      end
    end
  end

  def show_page_part(page_part)
    if page_part.new_record? || @selected_page_part == page_part
      'page_part_selected'
    else
      'page_part'
    end
  end

  def page_part_id(prefix, object)
    prefix + object.name.gsub(/\s+/, '_')
  end

  def parent_selected(page_parent)
    page_parent.nil? ? '' : page_parent.id.to_s
  end

end
