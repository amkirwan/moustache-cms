module MoustacheCms
  class TimeFormatted

    attr_reader :current_state, :published_at, :created_at, :updated_at

    @meth_prefix = ['', 'published_at_', 'created_at_', 'updated_at_']
    
    def initialize(klass)
      @current_state = klass.current_state.time 
      @published_at = klass.current_state.time
      @created_at = klass.created_at
      @updated_at = klass.updated_at
    end  

    @meth_prefix.each_with_index do |prefix, index|
      args = %w(created_at published_at created_at updated_at)

      define_method(prefix + 'formatted_date') do |time=self.send(args[index])|
        return "" if time.nil?
        time.strftime("%e %b %Y").strip
      end

      define_method(prefix + 'formatted_time') do |time=self.send(args[index])|
        return "" if time.nil?
        time.strftime("%l%P").strip
      end

      define_method(prefix + 'formatted_time_zone') do |time=self.send(args[index])| 
        return "" if time.nil?
        time.strftime("%Z").strip
      end

      define_method(prefix + 'formatted_date_and_time') do |time=self.send(args[index])| 
        return "" if time.nil?
        "#{formatted_date(time)} at #{formatted_time(time)}".strip
      end

      define_method(prefix + 'formatted_date_and_time_with_zone') do |time=self.send(args[index])| 
        return "" if time.nil?
        "#{formatted_date(time)} at #{formatted_time(time)} #{formatted_time_zone(time)}".strip
      end

      define_method(prefix + 'datetime_date') do |time=self.send(args[index])| 
        return "" if time.nil?
        "#{year(time)}-#{month(time)}-#{day(time)}"
      end

      define_method(prefix + 'datetime_iso8601') do |time=self.send(args[index])| 
        return "" if time.nil?
        time.iso8601
      end

      define_method(prefix + 'full_day_name') do |time=self.send(args[index])| 
        return "" if time.nil?
        time.strftime('%A')
      end

      define_method(prefix + 'abbv_day_name') do |time=self.send(args[index])| 
        return "" if time.nil?
        time.strftime('%a')
      end

      define_method(prefix + 'full_month_name') do |time=self.send(args[index])| 
        return "" if time.nil?
        time.strftime('%B')
      end

      define_method(prefix + 'abbv_month_name') do |time=self.send(args[index])| 
        return "" if time.nil?
        time.strftime('%b')
      end

      define_method(prefix + 'year') do |time=self.send(args[index])| 
        return "" if time.nil?
        time.strftime("%Y")
      end

      define_method(prefix + 'month') do |time=self.send(args[index])| 
        return "" if time.nil?
        time.strftime("%m")
      end

      define_method(prefix + 'day') do |time=self.send(args[index])| 
        return "" if time.nil?
        time.strftime("%d")
      end

      define_method(prefix + 'zone') do |time=self.send(args[index])| 
        return "" if time.nil?
        time.zone
      end
    end

  end
end
