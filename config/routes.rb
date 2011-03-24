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
  
  root :to => 'site#dynamic_page' 
  # Everything else 
  match "*url(.:format)", :to => "site#dynamic_page"
end
