module Admin::CurrentSiteHelper

  def manage_domains
    domains = @current_site.domains.delete_if { |x| x == "#{@current_site.full_subdomain}" }
    render :partial => 'admin/current_site/domains', :object => domains
  end
end
