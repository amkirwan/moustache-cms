module ControllerMacros
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  def setup(role)
    current_user = logged_in(:role? => role)
    cas_faker(current_user.username)
  end
  
  module ClassMethods     
    def it_should_require_admin_for_action(*actions) 
      actions.each do |action|
        it "#{action} action should require admin" do
          setup(false)
          controller.should_not_receive(action)
          get action, :id => 1 
          response.should render_template("#{Rails.root}/public/403.html") 
        end
      end
    end
    
    def it_should_allow_admin_for_action(*actions)
      actions.each do |action|
        it "#{action} action should allow admin" do
          setup(true)
          controller.stub(:render).and_return(true)      
          controller.should_receive(action)
          get action, :id => 1 
        end
      end
    end 
    
    def it_should_allow_non_admin_for_action(action, params)
      it "#{action} action should allow non admin to edit their record" do
        setup(true)
        controller.stub(:render).and_return(true)
        controller.should_receive(action)
        get action, :id => 1        
      end
    end         
  end
end