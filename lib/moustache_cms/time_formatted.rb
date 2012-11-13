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

    def datetime_date
      return "" if @current_state.time.nil?
      "#{year}-#{month}-#{day}"
    end

    def datetime_iso8601
      return "" if @current_state.time.nil?
      @current_state.time.iso8601
    end

    def full_weekday_name
      return "" if @current_state.time.nil?
      @current_state.time.strftime('%A')
    end

    def abbv_weekday_name
      return "" if @current_state.time.nil?
      @current_state.time.strftime('%a')
    end

    def full_month_name
      return "" if @current_state.time.nil?
      @current_state.time.strftime('%B')
    end
    
    def abbv_month_name
      return "" if @current_state.time.nil?
      @current_state.time.strftime('%b')
    end

    def year
      return "" if @current_state.time.nil?
      @current_state.time.year.to_s
    end

    def month
      return "" if @current_state.time.nil?
      @current_state.time.month.to_s
    end

    def day
      return "" if @current_state.time.nil?
      @current_state.time.day.to_s
    end

    def zone
      return "" if @current_state.time.nil?
      @current_state.time.zone
    end

  end
end
