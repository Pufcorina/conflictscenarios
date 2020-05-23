class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable, :rememberable, :confirmable

  def self.find_by_authentication_token(authentication_token = nil)
    if authentication_token
      where(authentication_token: authentication_token).first
    end
  end

  def password_match?
    self.errors[:password] << I18n.t('errors.messages.blank') if password.blank?
    self.errors[:password_confirmation] << I18n.t('errors.messages.blank') if password_confirmation.blank?
    self.errors[:password_confirmation] << I18n.translate("errors.messages.confirmation", attribute: "password") if password != password_confirmation
    password == password_confirmation && !password.blank?
  end

  # new function to set the password without knowing the current
  # password used in our confirmation controller.
  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    update_attributes(p)
  end

  # new function to return whether a password has been set
  def has_no_password?
    self.encrypted_password.blank?
  end

  # Devise::Models:unless_confirmed` method doesn't exist in Devise 2.0.0 anymore.
  # Instead you should use `pending_any_confirmation`.
  def only_if_unconfirmed
    pending_any_confirmation {yield}
  end

  def self.search(search_params)
    query_array = []
    querry_role = []
    if search_params.present?
      if search_params["user_search_email"].present? && search_params["user_search_email"] != ""
        query_array << "users.email ILIKE '%#{search_params["user_search_email"].strip.gsub(/\s+/, "% %")}%'"
      end
      if search_params["user_search_name"].present? && search_params["user_search_name"] != ""
        query_array << "(CONCAT(users.first_name, ' ', users.last_name) ILIKE '%#{search_params["user_search_name"].strip.gsub(/\s+/, "% %").gsub('\'', "''")}%' OR CONCAT(users.last_name, ' ', users.first_name) ILIKE '%#{search_params["user_search_name"].strip.gsub(/\s+/, "% %").gsub('\'', "''")}%')"
      end
      if search_params["user_search_phone"].present? && search_params["user_search_phone"] != ""
        query_array << "users.phone ILIKE '%#{search_params["user_search_phone"].strip.gsub(/\s+/, "% %")}%'"
      end
      if search_params["user_search_phone"].present? && search_params["user_search_phone"] != ""
        query_array << "users.phone ILIKE '%#{search_params["user_search_phone"].strip.gsub(/\s+/, "% %")}%'"
      end

      if search_params["user_search_admin"].present? && search_params["user_search_admin"] == "on"
        querry_role << "users.admin = true"
      end

      if search_params["user_search_manager"].present? && search_params["user_search_manager"] == "on"
        querry_role << "users.manager = true"
      end

      if search_params["user_search_employee"].present? && search_params["user_search_employee"] == "on"
        querry_role << "users.employee = true"
      end

      query_array << ("(" + querry_role.join(" OR ") + ")") if querry_role.present?

      where(query_array.join(" AND "))
    end
  end

  def self.search_email searched_string
    query_array = []
    if searched_string.present?
      query_array << "users.email ILIKE '%#{searched_string.strip.gsub(/\s+/, "% %")}%'"
      query_array << "(CONCAT(users.first_name, ' ', users.last_name) ILIKE '%#{searched_string.strip.gsub(/\s+/, "% %")}%' OR CONCAT(users.last_name, ' ', users.first_name) ILIKE '%#{searched_string.strip.gsub(/\s+/, "% %")}%')"
      query_array << "users.cell_phone ILIKE '%#{searched_string.strip.gsub(/\s+/, "% %")}%'"
    end
    where(query_array.join(" OR ")).order(:last_name, :first_name)
  end
end
