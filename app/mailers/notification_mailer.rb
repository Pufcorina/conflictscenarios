class NotificationMailer < Devise::Mailer
  default from: "donotreply@golfgenius.com", reply_to: "donotreply@golfgenius.com"
  layout "mail"
end
