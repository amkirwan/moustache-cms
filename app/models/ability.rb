class Ability
  include CanCan::Ability
  
  def initialize(user)      
    user ||= User.new    
    
    if user.role == "admin"
      can :manage, :all
    end
  end    
end