class EmailTemplateMailer < ApplicationMailer
  if Rails.env.production?
    default from: "Golf Genius Golf Shop <donotreply@golfgenius.com>", reply_to: "Golf Genius Golf Shop <donotreply@golfgenius.com>"
  elsif Rails.env.staging?
    default from: "Golf Genius Golf Shop <donotreply@gsgstaging.com>", reply_to: "Golf Genius Golf Shop <donotreply@gsgstaging.com>"
  else 
    default from: "Golf Genius Golf Shop <donotreply@golfgenius.com>", reply_to: "Golf Genius Golf Shop <donotreply@golfgenius.com>"
  end
  layout "email_template_mailer"

  def email(email_params, user = nil, customer)
    @body = email_params[:body]

    #set logo & banner
    setting = Setting.exist_or_create(customer.id)
    @banner_url = setting.try(:email_banner)
    @logo_url = setting.try(:email_logo)

    #set attachments
    if email_params[:attachment].present?
      attachments[email_params[:attachment].to_s] = email_params[:attachment]
    end

    #build email parameters
    mail_headers = {
      options: {ip_pool: "transactional"},
      tags: ["golfshop"]
    }
    from = Rails.env.staging? ? "#{customer.name.gsub(',',' ').gsub(';', ' ')} <donotreply@gsgstaging.com>" : "#{customer.name.gsub(',',' ').gsub(';', ' ')} <donotreply@golfgenius.com>"

    if email_params[:to].present?
      mail_parameters = {
        to: email_params[:to],
        bcc: email_params[:bcc],
        cc: email_params[:cc],
        reply_to: email_params[:reply_to],
        subject: email_params[:subject],
        from: from,
        "X-MSYS-API" => mail_headers.to_json
      }

      mail mail_parameters
    end
  end
end
