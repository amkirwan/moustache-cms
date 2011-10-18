module Admin::CurrentSiteHelper

  def site_domain_name_id(domain)
    'site_domain_name_' + domain.gsub(/\./, '_')
  end

  def can_manage_domain?(domain, index)
    if domain != @current_site.full_subdomain
      render :partial => 'admin/current_site/domain', :locals => { :domain => domain, :index => index }
    end
  end
   
  def manage_meta_tag current_site, meta_tag 
    case meta_tag.name
    when "title", "keywords", "description"
    else
      link_to "Delete", [:admin, current_site, meta_tag], :confirm => "Are you sure you want to delete the meta tag #{meta_tag.name}", :method => :delete, :class => "delete"
    end
  end


end
