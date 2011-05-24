Etherweb::Application.routes.draw do   
                              
  namespace :admin do
    resources :users
    resources :layouts, :except => :show
    resources :pages, :except => :show
    resources :site_assets
    resources :theme_css_js
  end
  
  match "/admin" => redirect("/admin/pages")
  
  scope :controller => "cms_site" do
    get "/" => :render_html, :as => "cms_html", :path => '(*page_path)'
  end
end
