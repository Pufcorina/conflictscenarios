class Users::ConfirmationsController < Devise::ConfirmationsController
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.blank?
      set_flash_message!(:notice, :confirmed)
      respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      flash[:notice] = "Email was already confirmed, please try signing in"
      redirect_to root_path
    end
  end 
 end
