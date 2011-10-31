class Ability
  include CanCan::Ability
  
  def initialize(user)      
    user ||= User.new   

    if user.role? :admin
      can :manage, Site do |site|
        site.users.include?(user)
      end

      can :create, PagePart
      can [:read, :update, :destroy], PagePart, do |page_part|
        page_part._parent.site_id == user.site_id
      end
      
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
        if meta_tag._parent.class.name == "Site"
          meta_tag._parent.id == user.site_id
        else
          meta_tag._parent.site_id == user.site_id
        end
      end 
    end
    
    if user.role? :designer
      can :index, User, :site_id => user.site_id
      can [:show, :update, :destroy], User, :puid => user.puid, :site_id => user.site_id
      can :manage, [Layout, Page, AssetCollection, ThemeAsset], :site_id => user.site_id
      can :create, SiteAsset
      can [:read, :update, :destroy], SiteAsset, do |site_asset|
        site_asset._parent.site_id == user.site_id
      end
      can :create, MetaTag
      can [:read, :update, :destroy], MetaTag, do |meta_tag|
        if meta_tag._parent.class.name == "Site"
          meta_tag._parent.id == user.site_id
        else
          meta_tag._parent.site_id == user.site_id
        end
      end
    end

    if user.role? :editor 
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
        if meta_tag._parent.class.name == "Site"
          meta_tag._parent.id == user.site_id
        else
          meta_tag._parent.site_id == user.site_id
        end
      end
    end
  end    
end
