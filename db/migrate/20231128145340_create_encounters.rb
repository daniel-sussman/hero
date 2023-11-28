class CreateEncounters < ActiveRecord::Migration[7.1]
  def change
    create_table :encounters do |t|
      t.references :user, null: false, foreign_key: true
      t.references :activity, null: false, foreign_key: true
      t.boolean :show_me_fewer
      t.boolean :clicked_on
      t.boolean :liked
      t.boolean :saved
      t.boolean :attended
      t.integer :rating
      t.string :review

      t.timestamps
    end
  end
end
