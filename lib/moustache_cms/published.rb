module MoustacheCms
  module Published
    def published?
      self.current_state.published?
    end
  
    def draft?
      self.current_state.draft?
    end
    
    def published_on
      self.current_state.published_on
    end  
    
    def status
      self.current_state.name
    end
  end
end
