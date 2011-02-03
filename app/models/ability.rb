class Ability
  include CanCan::Ability
  
  def initialize(user)      
    user ||= User.new
    
    if user.role? :admin
      can :manage, :all
    elsif user.role? :editor 
      can :manage, Pages  
      can :manage, User { |user| user == user }
    end
  end 
  
end