Etherweb::Application.routes.draw do   
                              
  namespace :admin do
    resources :users
  end  
  
  namespace :admin do
    resources :layouts, :except => :show
  end
  
  match "/admin" => redirect("/admin/users#index")
   
  root :to => "dashboard#index"       
end
