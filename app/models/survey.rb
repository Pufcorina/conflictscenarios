class Survey < ApplicationRecord
  include Rails.application.routes.url_helpers

  has_many :questions, dependent: :destroy, inverse_of: :survey
  accepts_nested_attributes_for :questions, allow_destroy: true, reject_if: proc { |attributes| attributes['title'].blank? }

  def self.dummy_structure c
    s = Survey.last
    m = User.first

    if s.present? && m.present?
      dummy_survey_link = s.link_for_member m
    else
      dummy_survey_link = "#"
    end

    Struct.new(:title, :description, :logo, :customer, :link, :link_for_member) \
          .new('Survey Test', 'Description test', 'Logo', c, 'url_preview_to_survey', dummy_survey_link)
  end

  def link_for_member member

    protocol = ActionMailer::Base.default_url_options[:protocol]

    host = ActionMailer::Base.default_url_options[:host]

    host = ("www." + host) if host == "gsgstaging.com"
    host = ("golfshop." + host) if host == "golfgenius.com"
    return "#{protocol}://#{host}#{fill_survey_member_survey_path(self.id, member.id, self.id)}"
  end

  def survey_percentage nb_responses
    nb_responses == 0 || self.nb_emails_sent_to_members == 0 ? 0 : (nb_responses / self.nb_emails_sent_to_members.to_f * 100).round(2)
  end


  def self.surveys_for_select surveys = []

    surveys_for_select =  Array.new()
    surveys_for_select << ["Select existing survey..", 0]

    surveys.each do |survey|
      surveys_for_select << ["#{survey.title}", survey.id.to_s]
    end
    return surveys_for_select
  end

  def first_sync_name
    first_sync ? "Sync Answers" : "Import Answers"
  end

end
