class UserMailer < ApplicationMailer
  default from: "donotreply@golfgenius.com", reply_to: "donotreply@golfgenius.com"
  layout "mail"

  def signup_confirmation(user)
    @user = user
    @banner_url = nil
    @logo_url = nil
    if user.customer_id.present?
      values = get_logo_banner(user)
      @banner_url = values.first
      @logo_url = values.second
    end
    mail to: user.email, subject: "Sign Up Confirmation"
  end

  def reset_password(user)
    @user = user
    values = get_logo_banner(user)
    @banner_url = values.first
    @logo_url = values.second
    mail to: user.email, subject: "Reset Password"
  end

  def notification_deleted_from_club(user, customer_name)
    @user = user
    @customer_name = customer_name
    values = get_logo_banner(user)
    @banner_url = values.first
    @logo_url = values.second
    mail to: user.email, subject: "Notification deleted from club"
  end

  def notification_admin_deleted(admin)
    @user = admin
    @banner_url = nil
    @logo_url = nil
    mail to: admin.email, subject: "Notification admin deleted"
  end

  def signup_confirmation_admin(user)
    @user = user
    @banner_url = nil
    @logo_url = nil
    mail to: user.email, subject: "Sign Up Confirmation"
  end

  def notification_registered_to_club(user)
    @user = user
    values = get_logo_banner(user)
    @banner_url = values.first
    @logo_url = values.second
    mail to: user.email, subject: "Notification registered to club"
  end

  def get_logo_banner user
    return nil, nil if user.customer_id.blank?

    customer = Customer.find(user.customer_id)
    setting = Setting.exist_or_create(customer.id)
    banner_url = setting.try(:email_banner)
    logo_url = setting.try(:email_logo)

    return banner_url, logo_url
  end
end
