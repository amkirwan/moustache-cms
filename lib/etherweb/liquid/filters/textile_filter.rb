module TextileFilter

  def textilize(input)
    RedCloth.new(input).to_html
  end

end
::Liquid::Template.register_filter(TextileFilter)