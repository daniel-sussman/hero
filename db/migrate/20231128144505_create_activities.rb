class CreateActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :activities do |t|
      t.string :title
      t.text :description
      t.string :photo_url
      t.float :latitude
      t.float :longitude
      t.time :monday_opening_time
      t.time :monday_closing_time
      t.time :tuesday_opening_time
      t.time :tuesday_closing_time
      t.time :wednesday_opening_time
      t.time :wednesday_closing_time
      t.time :thursday_opening_time
      t.time :thursday_closing_time
      t.time :friday_opening_time
      t.time :friday_closing_time
      t.time :saturday_opening_time
      t.time :saturday_closing_time
      t.time :sunday_opening_time
      t.time :sunday_closing_time

      t.timestamps
    end
  end
end
