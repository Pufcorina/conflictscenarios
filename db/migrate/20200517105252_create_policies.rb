class CreatePolicies < ActiveRecord::Migration[5.2]
  def change
    create_table :policies do |t|
      t.string :name
      t.string :content
    end

    policies = ['privacy_policy', 'terms_and_conditions', 'cookie_policy']
    policies.each do |p|
      Policy.create! do |u|
        u.name = p
      end
    end

  end
end

