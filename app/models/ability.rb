class Ability
  include CanCan::Ability
  
  def initialize(user)      
    user ||= User.new   

    if user.role? :admin
      can :manage, [User, Layout, Page, AssetCollection, SiteAsset, ThemeAsset], :site_id => user.site_id
      can :manage, Site do |site|
        site.users.include?(user)
      end
    end
    
    if user.role? :designer
      can :index, User, :site_id => user.site_id
      can [:show, :update, :destroy], User, :puid => user.puid, :site_id => user.site_id
      can :manage, [Layout, Page, AssetCollection, SiteAsset, ThemeAsset], :site_id => user.site_id
    end

    if user.role? :editor 
      can :index, User, :site_id => user.site_id
      can [:show, :update, :destroy], User, :puid => user.puid, :site_id => user.site_id
      can [:create, :read], Page, :site_id => user.site_id
      can [:update, :destroy], Page do |page|
        page.editors.include?(user) && page.site_id == user.site_id
      end
      can [:read], AssetCollection, :site_id => user.site_id
      
      can [:read, :create, :update], SiteAsset, :site_id => user.site_id  
      can :destroy, SiteAsset, :created_by_id => user.id, :site_id => user.site_id
    end
  end    
end