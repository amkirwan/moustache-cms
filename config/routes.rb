Etherweb::Application.routes.draw do   
                              
  devise_for :users, :path => "admin" do
    get "admin/login", :to => "devise/sessions#new"
    delete "admin/logout", :to => "devise/sessions#destroy"  
    get "admin/users", :to => "admin/users#index", :as => :user_root 
  end 
  namespace :admin do
    resources :users
  end    
  match "/admin" => redirect("/admin/login")

   
  root :to => "dashboard#index" 
end
