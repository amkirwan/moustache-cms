module FormHelpers  
   
  def form_new(options, &block)
    form(:action => options[:action], &block)
  end
  
  def form_update(options, &block)
    form(:action => options[:action], &block)
  end
  
  private
  
  def form(options)
    rendered.should have_selector("form", :method => "post", :action => options[:action]) do |f|
      yield f
    end
  end
end