class ChangeEncounterColumns < ActiveRecord::Migration[7.1]
  def change
    change_column :encounters, :show_me_fewer, :boolean, null: false, default: false
    change_column :encounters, :clicked_on, :boolean, null: false, default: false
    change_column :encounters, :liked, :boolean, null: false, default: false
    change_column :encounters, :saved, :boolean, null: false, default: false
    change_column :encounters, :attended, :boolean, null: false, default: false
  end
end
