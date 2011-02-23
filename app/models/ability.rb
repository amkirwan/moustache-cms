class Ability
  include CanCan::Ability
  
  def initialize(user)      
    user ||= User.new    

    if user.role? :admin
      can :manage, :all
    end
    
    if user.role? :editor 
      can :update, User, :puid => user.puid
      can :show, User, :puid => user.puid
      can :edit, Page
    end
  end    
end