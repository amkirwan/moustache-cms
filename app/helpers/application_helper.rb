module ApplicationHelper  
  def admin?     
    yield if @current_user.role?("admin")
  end
end
