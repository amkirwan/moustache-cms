module MoustacheCms::Models
  module StateSetable
    extend ActiveSupport::Concern

    included do
      attr_accessible :current_state, :current_state_attributes

      embeds_one :current_state, 
                 :as => :publishable,
                 :cascade_callbacks => true 
                
      accepts_nested_attributes_for :current_state

      validates :current_state, :presence => true
    end
  end
end
