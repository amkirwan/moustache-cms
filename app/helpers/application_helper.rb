module ApplicationHelper  
  def admin?     
    @current_user.role?("admin") ? true : false
  end
end
