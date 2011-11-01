module Admin::MetaTagsHelper

  def add_meta_tag(message, base_object)
    if base_object.new_record?
      content_tag :p, :id => 'meta_tag_message' do
        content_tag :i, message
      end
    else
      link_to "Add Meta Tag", [:new, :admin, base_object, :meta_tag], :remote => true
    end
  end

end
