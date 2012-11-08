module MoustacheCms 
  module Admin::CustomFieldsHelper

    def add_custom_field(message, base_object, path)
      if base_object.new_record?
        content_tag :p, :id => 'custom_field_message' do
          content_tag :i, message
        end
      else
        link_to "Add Custom Field", path, :remote => true
      end
    end

  end
end
