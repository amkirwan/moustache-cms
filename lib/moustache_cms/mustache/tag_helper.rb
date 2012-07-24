class TagHelper
  include Singleton
  include ActionView::Helpers

  def page_full_path_with_request(request, page)
    "#{request.protocol}#{request.host.downcase}" + page.full_path
  end
end
