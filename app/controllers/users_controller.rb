class UsersController < ApplicationController
  before_action :authenticate_user!
  helper_method :sort_column, :sort_direction
  load_and_authorize_resource


  def index
    if params[:sort].blank?
      sort_column = "users.first_name"
      @default_sort = "users.first_name"
    else
      sort_column = sort_column()
      @default_sort = nil
    end
    if search_params.present? || params[:sort].blank?
      session['search_params'] = search_params
    else
      if session['search_params'].blank?
        session['search_params'] = nil
      end
    end

    @search_params = session['search_params']
    @reset = params[:reset]

    if @reset.present? || @search_params.blank?
      @search_params = nil
      session['search_params'] = nil
      @users = User.all.order(sort_column + " " + sort_direction)
    else
      @users = User.search(@search_params).order(sort_column + " " + sort_direction).distinct
    end

    respond_to do |format|
      format.js {render 'users/users_search'}
      format.html {render "users/index"}
    end
  end

  def new
    @user = User.new

    respond_to do |format|
      format.js
    end
  end

  def create
    @user = User.new(email: params["email"], first_name: params["first_name"], last_name: params["last_name"])

    @user[:admin] = params["role"] == "admin" ? true : false
    @user[:manager] = params["role"] == "manager" ? true : false
    @user[:employee] = @user[:admin] == true ? false : true

    if @user.save(validate: false)
      # UserMailer.signup_confirmation(@user).deliver
      redirect_to users_path and return
    else
      flash[:error] = "A aparut o eroare la adaugarea unui nou utilizator."
      redirect_to users_path and return
    end
  end



  def edit
    @user = User.find(params[:id]) || current_user
  end



  def update
    @user = User.find(params[:id])
    user_param = user_params.reject{ |k,v| ["password_confirmation", "current_password", "password"].include?(k)}
    new_user = @user
    if @user.valid_password?(user_params["current_password"]) && user_params["password"] == user_params["password_confirmation"]
      new_user.password = new_user.password_confirmation = user_params["password"]
    end
    new_user[:admin] = params["role"] == "admin" ? true : false
    new_user[:manager] = params["role"] == "manager" ? true : false
    @user[:employee] = @user[:admin] == true ? false : true
    user_param.each do |attribute, value|
      value = Date.strptime(value, "%Y-%m-%d") if attribute == "date_of_birth" && value.present?
      new_user[attribute.to_sym] = value
    end
    
    new_user.validate_user = true

    if new_user.save
      flash[:notice] = "Modificarea s-a efectuat cu success."
      redirect_to edit_user_path and return
    else
      flash[:error] = "Eroare la modificarea profilului."
      render 'edit'
    end
  end



  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "Stergerea s-a efectuat cu success."
    redirect_to users_path and return
  end


  private
  def user_params
    if params["action"] != "create"
      params.require(:user).permit( :first_name, :last_name, :email, :password, :password_confirmation, :phone, :current_password, :date_of_birth, :city, :country, :gender, :id)
    else
      params.permit(:first_name, :last_name, :email)
    end
  end

  def load_user
    user = User.find(params[:id])
  end

  def prepare_params
    if params[:user][:password].blank? && \
        params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
  end


  def sort_column
    params[:sort]
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def search_params
    params.permit(:utf8, :commit,:user_search_name,:user_search_email, :user_search_phone, :user_search_admin, :user_search_manager, :user_search_employee)
  end
end
