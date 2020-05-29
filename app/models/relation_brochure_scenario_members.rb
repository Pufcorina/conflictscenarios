class RelationBrochureScenarioMembers < ApplicationRecord
  has_many :surveys
  has_many :users
  has_many :brochures
end
