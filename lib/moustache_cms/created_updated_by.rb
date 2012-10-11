module MoustacheCms
  module CreatedUpdatedBy
    extend ActiveSupport::Concern

    included do
      validates :created_by_id,
                :presence => true  
                
      validates :updated_by_id,
                :presence => true
    end

    module ClassMethods
      def created_updated(inverse)
        created = inverse.to_s + '_created'
        updated = inverse.to_s + '_updated'
        belongs_to :created_by, :class_name => "User", :inverse_of => created.to_sym
        belongs_to :updated_by, :class_name => "User", :inverse_of => updated.to_sym
      end
    end
  end
end
