class Ability
  include CanCan::Ability
  
  def initialize(user)      
    user ||= User.new    

    if user.role? :admin
      can :manage, Site 
      can :manage, :all, :site_id => user.site_id
    end
    
    if user.role? :editor 
      cannot :manage, Site
      can :update, User, puid: user.puid, :site_id => user.site_id
      can :show, User, puid: user.puid, :site_id => user.site_id
      can :create, Page, :site_id => user.site_id
      can :index, Page, :site_id => user.site_id
      can [:show, :update, :destroy], Page do |page|
        page.editors.include?(user) && user.site_id
      end
    end
  end    
end