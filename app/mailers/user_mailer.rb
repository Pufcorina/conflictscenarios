class UserMailer < ApplicationMailer
  default from: "it@eightinvestmentgroup.com", reply_to: "it@eightinvestmentgroup.com"
  layout "mail"

  def confirmation_instructions(user, token, details)
    @user = user
    mail to: user.email, subject: "Sign Up Confirmation"
  end

  def reset_password_instructions(user, token, details)
    @user = user
    @token = token
    mail to: user.email, subject: "Reset Password Instructions"

  end


  def reset_password(user)
    @user = user
    mail to: user.email, subject: "Reset Password"
  end


end
