class Ability
  include CanCan::Ability
  
  def initialize(user)      
    user ||= User.new   

    if user.role? :admin
      can :manage, [User, Layout, Page, MediaFile, CssFile], :site_id => user.site_id
      can :manage, Site do |site|
        site.users.include?(user)
      end
    end
    
    if user.role? :designer
      can :index, User, :site_id => user.site_id
      can [:show, :update, :destroy], User, :puid => user.puid, :site_id => user.site_id
      can :manage, [Layout, Page, MediaFile, CssFile], :site_id => user.site_id
    end

    if user.role? :editor 
      can :index, User, :site_id => user.site_id
      can [:show, :update, :destroy], User, :puid => user.puid, :site_id => user.site_id
      can [:create, :read], Page, :site_id => user.site_id
      can [:update, :destroy], Page do |page|
        page.editors.include?(user) && page.site_id == user.site_id
      end
      can [:create, :read, :update], MediaFile, :site_id => user.site_id
      can :destroy, MediaFile, :site_id => user.site_id, :created_by_id => user.id
    end
  end    
end