class MoustacheCms::Ability
  include CanCan::Ability
  
  def initialize(user)
    user ||= User.new

    if user.role? :editor
      set_editor_roles(user)
    end

    if user.role? :designer
      set_designer_roles(user)
    end

    if user.role? :admin
      set_admin_roles(user)
    end
  end

  private

  def set_editor_roles(user)
    can :read, [User, Page, ArticleCollection, AssetCollection], :site_id => user.site_id  

    [SiteAsset, PagePart, MetaTag].each do |klass| 
      set_role(klass, user, :manage)
    end

    can [:update, :destroy], User, :username => user.username, :site_id => user.site_id
    can :change_password, User, :id => user.id, :site_id => user.site_id

    can [:update, :destroy], Page do |page|
      page.editors.include?(user) && page.site_id == user.site_id
    end
    
    can :manage, Article do |article|
      article.article_collection.editors.include?(user) && article.site_id == user.site_id
    end

    cannot :manage, [Site, Layout, ThemeAsset, Snippet]    
  end

  def set_designer_roles(user)
    can :manage, [Layout, ThemeCollection, Snippet, Author], :site_id => user.site_id  
    can :manage, ThemeAsset do |theme_asset|
      theme_asset._parent.site_id == user.site_id
    end  
  end

  def set_admin_roles(user)
    can [:read, :create], Site
    can [:update, :destroy], Site, :id => user.site_id
    can :manage, [Page, ArticleCollection, Article, AssetCollection, User], :site_id => user.site_id
    cannot :change_password, User do |u|
      u.id != user.id
    end

    can :manage, MetaTag do |meta_tag|
      if meta_tag._parent.class.name == "Site"
        meta_tag._parent.id == user.site_id
      end
    end
    can :manage, CustomField
  end

  def set_role(klass, user, *roles)
    can roles, klass do |obj|
      if obj._parent.respond_to?(:site_id)
        obj._parent.site_id == user.site_id
      end
    end
  end

end
