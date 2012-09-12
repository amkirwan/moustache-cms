require File.expand_path(File.join(Rails.root, 'lib', 'moustache_cms', 'articles_constraint'))

MoustacheCms::Application.routes.draw do   

  namespace :admin do

    devise_for :users, :path => '', :controllers => { :sessions => 'admin/sessions', :passwords => 'admin/passwords' } 

    resources :users do
      member do
        get :change_password
      end
    end
    resources :layouts

    resources :pages do 
      put :sort, :on => :member
      get :new_meta_tag, :on => :collection
      put :preview, :on => :member, :as => :preview
      resources :meta_tags, :except => [:index, :show] 
      resources :custom_fields, :only => [:new, :destroy]
      resources :page_parts, :except => [:index, :new, :update] 
    end

    resources :authors

    resources :article_collections do
      resources :articles do
        get :new_meta_tag, :on => :collection
        resources :meta_tags, :except => [:index, :show] 
      end
    end

    match 'articles/new_meta_tag' => 'articles#new_meta_tag', :as => 'articles_new_meta_tag'

    resources :theme_collections do
      resources :theme_assets do
        resources :custom_fields, :only => [:new, :destroy]
      end
    end

    resources :snippets 

    resources :asset_collections do
      resources :site_assets
    end

    resources :sites, :path => 'current_site', :controller => 'current_site' do
      resources :meta_tags, :except => :index 
      resources :domain_names, :except => [:index, :show]
    end
  end

  match "/admin" => redirect("/admin/pages")

  match "*articles" => 'cms_site#render_html', :as => :articles, :constraints => MoustacheCms::ArticlesConstraint.new
  match "*articles/page/:page" => 'cms_site#render_html', :as => :articles_page, :constraints => MoustacheCms::ArticlesConstraint.new
  match "*articles/:year/:month/:day/:title" => 'cms_site#render_html', :as => :article_permalink, :constraints => MoustacheCms::ArticlesConstraint.new
  match ":year/:month/:day/:title" => 'cms_site#render_html', :constraints => { :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/ }
  match "page/:page" => 'cms_site#render_html', :constraints => { :id => /\d/ }


  scope :controller => "cms_site" do
    get "/" => :render_html, :as => "cms_html", :path => '(*page_path)'
  end
  root :to => 'admin/pages#index'
end
