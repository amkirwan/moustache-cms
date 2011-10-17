module Admin::MetaTagsHelper

  def add_meta_tag(message, base_class)
    if base_class.new_record?
      content_tag :p do
        content_tag :i, message
      end
    else
      link_to "Add Meta Tag", [:new, :admin, base_class, :meta_tag], :remote => true
    end
  end

end
