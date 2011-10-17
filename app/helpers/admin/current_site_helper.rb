module Admin::CurrentSiteHelper

  def manage_domains(f_builder)
    domain_names = @current_site.domain_names.delete_if { |domain| domain == "#{@current_site.full_subdomain}" }
    render :partial => 'admin/current_site/domains', :object => domain_names, :locals => { :f_builder => f_builder }
  end

  def manage_meta_tag current_site, meta_tag 
    case meta_tag.name
    when "title", "keywords", "description"
    else
      link_to "Delete", [:admin, current_site, meta_tag], :confirm => "Are you sure you want to delete the meta tag #{meta_tag.name}", :method => :delete, :class => "delete"
    end
  end


end
