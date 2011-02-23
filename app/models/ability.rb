class Ability
  include CanCan::Ability
  
  def initialize(user)      
    user ||= User.new    

    if user.role? :admin
      can :manage, :all
    end
    
    if user.role? :editor 
      can :edit, User, :username => user.username
      can :show, User, :username => user.username
      can :edit, Page
    end
  end    
end