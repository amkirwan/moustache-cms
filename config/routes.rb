HandlebarCms::Application.routes.draw do   
                              
  namespace :admin do
    resources :users
    resources :layouts, :except => :show
    resources :pages, :except => :show do 
      resources :meta_tags, :except => [:index, :show]
    end
    resources :theme_assets   
    resources :snippets        
    resources :asset_collections do
      resources :site_assets 
    end
    resources :site, :except => :show
  end
  
  match "/admin" => redirect("/admin/pages")

  match "/logout", :to => "admin_base#logout"
  
  scope :controller => "cms_site" do
    get "/" => :render_html, :as => "cms_html", :path => '(*page_path)'
  end
end
