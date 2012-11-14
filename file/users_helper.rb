module Admin::UsersHelper

  def new_password_fields?
    @user.new_record? && @user.respond_to?(:password) ? true : false
  end

  def can_change_password?
    if @user.respond_to?(:password) && @user == @current_admin_user
      true
    end
  end

end
