Etherweb::Application.routes.draw do   
                              
  namespace :admin do
    resources :users
  end    
  
  match "/admin" => redirect("/admin/users#index")
   
  root :to => "dashboard#index"       
  
  match "fake_cas_login" => "fake_cas_login#login", :as => "fake_cas_login"
end
