class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only, :except => :show
  helper_method :sort_column, :sort_direction

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    binding.pry
    params_user = user_params
    params_user[:password] = SecureRandom.hex(8)
    @user = User.new(params_user)
    @user.save

  end

  def show
    @user = User.find(params[:id])
    unless current_user.admin?
      unless @user == current_user
        redirect_to root_path, :alert => "Access denied."
      end
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(secure_params)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to users_path, :notice => "User deleted."
  end

  def sort_column
    params[:sort]
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  private



  def admin_only
    unless current_user.admin?
      redirect_to root_path, :alert => "Access denied."
    end
  end

  def secure_params
    params.require(:user).permit(:role)
  end

  def user_params
    params.require(:user).permit(:role, :name, :email)
  end

end
