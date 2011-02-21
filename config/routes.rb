Etherweb::Application.routes.draw do   
                              
  namespace :admin do
    resources :users, :except => :show
  end 
  
  match "/admin" => redirect("/admin/users#index")
   
  root :to => "dashboard#index"       
end
