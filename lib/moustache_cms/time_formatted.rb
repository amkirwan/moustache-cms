module MoustacheCms
  class TimeFormatted

    def initialize(klass)
      @current_state = klass.current_state.time 
      @published_at = klass.current_state.time
      @created_at = klass.created_at
      @updated_at = klass.updated_at
    end  

    def formatted_date_and_time_with_zone(time=@published_at)
      return "" if time.nil?
      "#{formatted_date(time)} at #{formatted_time(time)} #{formatted_time_zone(time)}".strip
    end

    # def respond_to?(method)
    #   method_name = method.to_s
    #   if method_name =~ /^(published_at)_(.*)/ 
    #     return true
    #   else
    #     super
    #   end
    # end
    
    def method_missing(method, *args, &block)
      method_name = method.to_s
      if method_name =~ /^(published_at)_(.*)/ && self.respond_to?($2)
          self.send($2, self.instance_variable_get('@' + $1))
      else
        super
      end
    end

    def formatted_date_and_time
      return "" if @current_state.time.nil?
      "#{formatted_date} at #{formatted_time}".strip
    end
    
    def formatted_date(time)
      return "" if time.nil?
      time.strftime("%e %b %Y").strip
    end

    def formatted_time(time)
      return "" if time.nil?
      time.strftime("%l%P").strip
    end

    def formatted_time_zone(time)
      return "" if time.nil?
      time.strftime("%Z").strip
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
      @current_state.time.strftime("%Y")
    end

    def month
      return "" if @current_state.time.nil?
      @current_state.time.strftime("%m")
    end

    def day
      return "" if @current_state.time.nil?
      @current_state.time.strftime("%d")
    end

    def zone
      return "" if @current_state.time.nil?
      @current_state.time.zone
    end

  end
end
