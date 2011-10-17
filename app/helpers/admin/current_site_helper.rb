module Admin::CurrentSiteHelper

  def manage_domains(f_builder)
    domain_names = @current_site.domain_names.delete_if { |domain| domain == "#{@current_site.full_subdomain}" }
    render :partial => 'admin/current_site/domains', :object => domain_names, :locals => { :f_builder => f_builder }
  end
end
