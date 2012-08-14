module MoustacheCms
  class ArticlesConstraint
    include MoustacheCms::RequestCurrentSite

    def matches?(request)
      articles(request).map { |a| a.name }.include?(request.params[:articles])
    end

    def articles(request)
      @current_site ||= request_current_site(request)
      @article_collections ||= @current_site.article_collections
    end
  end
end
