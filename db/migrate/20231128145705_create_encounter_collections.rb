class CreateEncounterCollections < ActiveRecord::Migration[7.1]
  def change
    create_table :encounter_collections do |t|
      t.references :collection, null: false, foreign_key: true
      t.references :encounter, null: false, foreign_key: true

      t.timestamps
    end
  end
end
