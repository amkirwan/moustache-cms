module Admin::MetaTagsHelper

  def add_meta_tag(message)
    if @page.new_record?
      content_tag :p do
        content_tag :i, message
      end
    else
      link_to "Add Meta Tag", [:new, :admin, @page, :meta_tag], :remote => :true
    end
  end

end
