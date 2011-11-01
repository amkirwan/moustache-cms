module Admin::PagePartsHelper

 def add_page_part
    if @page.new_record?
      content_tag :p, content_tag(:i, "Save page first to add additonal page parts")
    else
      link_to 'add page part', [:edit, :admin, @page, :page_part]
    end
  end

end
