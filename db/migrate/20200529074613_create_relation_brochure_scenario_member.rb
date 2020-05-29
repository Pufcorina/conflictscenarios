class CreateRelationBrochureScenarioMember < ActiveRecord::Migration[5.2]
  def change
    create_table :relation_brochure_scenario_members do |t|
      t.bigint :user_id
      t.bigint :survey_id
      t.bigint :brochure_id

      t.timestamps
    end

    create_table :relation_brochure_scenarios do |t|
      t.bigint :survey_id
      t.bigint :brochure_id

      t.timestamps
    end
  end
end
