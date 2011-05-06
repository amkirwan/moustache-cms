Etherweb::Application.routes.draw do   
                              
  namespace :admin do
    resources :users
    resources :media_files
    resources :layouts, :except => :show
    resources :pages, :except => :show
  end
  
  match "/admin" => redirect("/admin/pages")
  
  scope :controller => "cms_site" do
    get "/" => :render_html, :as => "cms_html", :path => '(*page_path)'
  end
end
