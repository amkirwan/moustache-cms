Etherweb::Application.routes.draw do   
                              
  namespace :admin do
    resources :users
  end  
  
  namespace :admin do
    resources :layouts, :except => :show
    resources :pages, :except => :show
  end
  
  match "/admin" => redirect("/admin/pages#index")
  
  scope :controller => "site" do
    get "/" => :render_html, :as => "cms_html", :path => '(*page_path)'
  end
end
