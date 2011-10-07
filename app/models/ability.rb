class Ability
  include CanCan::Ability
  
  def initialize(user)      
    user ||= User.new   

    if user.role? :admin
      can :manage, TagAttr
      can :manage, [User, Layout, Page, AssetCollection, ThemeAsset, Snippet], :site_id => user.site_id
      # Because SiteAsset is embedded in ThemeAsset you cannot save a created SiteAsset in another site
      # unless you are approved to save the ThemeAsset. When using new and create the _parent of the SiteAsset
      # will not have been set and it cannot be saved without the parent. Same applies to meta_tags
      can :create, SiteAsset
      can [:read, :update, :destroy], SiteAsset, do |site_asset|
        site_asset._parent.site_id == user.site_id
      end
      can :create, MetaTag
      can [:read, :update, :destroy], MetaTag, do |meta_tag|
        meta_tag._parent.site_id == user.site_id
      end 
      can :manage, Site do |site|
        site.users.include?(user)
      end
    end
    
    if user.role? :designer
      can :manage, TagAttr
      can :index, User, :site_id => user.site_id
      can [:show, :update, :destroy], User, :puid => user.puid, :site_id => user.site_id
      can :manage, [Layout, Page, AssetCollection, ThemeAsset], :site_id => user.site_id
      can :create, SiteAsset
      can [:read, :update, :destroy], SiteAsset, do |site_asset|
        site_asset._parent.site_id == user.site_id
      end
      can :create, MetaTag
      can [:read, :update, :destroy], MetaTag, do |meta_tag|
        meta_tag._parent.site_id == user.site_id
      end
    end

    if user.role? :editor 
      can :manage, TagAttr
      can :index, User, :site_id => user.site_id
      can [:show, :update, :destroy], User, :puid => user.puid, :site_id => user.site_id    
      
      can [:create, :read], Page, :site_id => user.site_id
      can [:update, :destroy], Page do |page|
        page.editors.include?(user) && page.site_id == user.site_id
      end   
      
      can [:read], AssetCollection, :site_id => user.site_id   
      can :create, SiteAsset   
      can [:read, :update, :destroy], SiteAsset, do |site_asset|
        site_asset._parent.site_id == user.site_id
      end
      can :create, MetaTag
      can [:read, :update, :destroy], MetaTag, do |meta_tag|
        meta_tag._parent.site_id == user.site_id
      end

    end
  end    
end
