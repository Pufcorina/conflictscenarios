class Question < ApplicationRecord
  belongs_to :survey
  has_many :member_questions, dependent: :destroy
  has_many :options
  accepts_nested_attributes_for :options, allow_destroy: true, reject_if: proc { |attributes| attributes['title'].blank? }
end
