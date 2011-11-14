HandlebarCms::Application.routes.draw do   
                              
  #devise_for :admin, :class_name => 'User', :controllers => { :sessions => 'admin/sessions', :passwords => 'admin/passwords', :registration => 'admin/registrations' }, :path => 'admin'

  namespace :admin do

    devise_for :users
    resources :users
    resources :layouts

    resources :pages do 
      put :sort, :on => :member
      get :new_meta_tag, :on => :collection
      resources :meta_tags, :except => [:index, :show] 
      resources :page_parts, :only => [:show, :create, :destroy]
    end


    resources :theme_assets do
      resources :tag_attrs
    end  

    resources :snippets 

    resources :asset_collections do
      resources :site_assets
    end

    resources :sites, :path => 'current_site', :controller => 'current_site', :except => [:index] do
      resources :meta_tags, :except => :index 
      resources :domain_names, :except => [:index, :show]
    end

  end

  match "/admin" => redirect("/admin/pages")

  scope :controller => "cms_site" do
    get "/" => :render_html, :as => "cms_html", :path => '(*page_path)'
  end
end
