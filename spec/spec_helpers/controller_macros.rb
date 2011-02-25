module ControllerMacros
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  def setup(klass, role)
    current_user = logged_in(:role? => role)
    cas_faker(current_user.username)
    klass.stub(:find).and_return(true)
    klass.stub(:accessible_by).and_return(true)
  end
  
  module ClassMethods     
    def it_should_require_admin_for_action(klass, *actions) 
      actions.each do |action|
        it "#{action} action should require admin" do
          setup(klass, false)
          controller.should_not_receive(action)
          get action, :id => 1 
          response.should render_template("#{Rails.root}/public/403.html") 
        end
      end
    end
    
    def it_should_allow_admin_for_action(klass, *actions)
      actions.each do |action|
        it "#{action} action should allow admin" do
          setup(klass, true)
          controller.stub(:render).and_return(true)      
          controller.should_receive(action)
          get action, :id => 1 
        end
      end
    end 
    
    def it_should_allow_non_admin_for_action(klass, action, params)
      it "#{action} action should allow non admin to edit their record" do
        setup(klass, true)
        controller.stub(:render).and_return(true)
        controller.should_receive(action)
        get action, :id => 1        
      end
    end         
  end
end