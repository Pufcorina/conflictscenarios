class RelationBrochureScenarios < ApplicationRecord
  has_many :surveys
  has_many :brochures
end
