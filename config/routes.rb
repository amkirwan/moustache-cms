Etherweb::Application.routes.draw do   
                              
  namespace :admin do
    resources :users
  end    
  
  match "fake_cas_login" => "fake_cas_login#login", :as => "fake_cas_login"
  
  match "/admin" => redirect("/admin/users#index")
   
  root :to => "dashboard#index" 
end
