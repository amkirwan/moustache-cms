HandlebarCms::Application.routes.draw do   
                              
  namespace :admin do
    resources :users
    resources :layouts

    resources :pages, :except => :show do 
      put :sort, :on => :member
      resources :meta_tags, :except => [:index, :show]
    end

    resources :theme_assets do
      resources :tag_attrs
    end  

    resources :snippets        

    resources :asset_collections do
      resources :site_assets
    end

    resources :sites, :path => 'current_site', :controller => 'current_site', :except => [:index, :show] do
      resources :meta_tags, :except => [:index, :show] 
      resources :domain_names, :except => [:index, :show]
    end

  end
  
  match "/admin" => redirect("/admin/pages")

  match "/logout", :to => "admin_base#logout"
  
  scope :controller => "cms_site" do
    get "/" => :render_html, :as => "cms_html", :path => '(*page_path)'
  end
end
