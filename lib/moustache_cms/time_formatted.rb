module MoustacheCms
  class TimeFormatted
    def initialize(current_state)
      @current_state = current_state
    end  

    def formatted_date_and_time_with_zone
      return "" if @current_state.time.nil?
      "#{formatted_date} at #{formatted_time} #{formatted_time_zone}".strip
    end

    def formatted_date_and_time
      return "" if @current_state.time.nil?
      "#{formatted_date} at #{formatted_time}".strip
    end
    
    def formatted_date
      return "" if @current_state.time.nil?
      @current_state.time.strftime("%e %b %Y").strip
    end

    def formatted_time
      return "" if @current_state.time.nil?
      @current_state.time.strftime("%l%P").strip
    end

    def formatted_time_zone
      return "" if @current_state.time.nil?
      @current_state.time.strftime("%Z").strip
    end

  end
end
