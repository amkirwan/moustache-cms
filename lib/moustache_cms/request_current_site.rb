module MoustacheCms
  module RequestCurrentSite
    def request_current_site(request_set = nil)
      if request_set.nil?
        Site.match_domain(request.host.downcase).first
      else
        Site.match_domain(request_set.host.downcase).first
      end
    end
  end
end
