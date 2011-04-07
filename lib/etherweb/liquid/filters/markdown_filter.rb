module MarkdownFilter
        
  def markdownize(input)
    RDiscount.new(input).to_html
  end
    
end
