# Remove empty nodes. When using mustache tags within markdown it can cause 
# empty paragraph tags because of spacing issues.
# 
class String
  def clean_html
    doc = Nokogiri::HTML(self)
    doc.css('p').each { |node| node.remove if node.inner_text == '' }
    doc.to_html
  end
end
