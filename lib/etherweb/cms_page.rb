class Etherweb::CmsPage < ::Mustache
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  
  def initialize(controller)
    @controller = controller
  end
  
  def yield
    render @page.page_parts.each { |part| part.content }
  end
  
end