Etherweb::Application.routes.draw do   
                              
  namespace :admin do
    resources :users
  end  
  
  namespace :admin do
    resources :layouts, :except => :show
  end
  
  namespace :admin do
    resources :pages, :except => :shwo
  end
  
  match "/admin" => redirect("/admin/pages#index")
   
  root :to => "dashboard#index"       
end
