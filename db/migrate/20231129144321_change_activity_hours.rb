class ChangeActivityHours < ActiveRecord::Migration[7.1]
  def change
    remove_column :activities, :monday_opening_time, :time
    remove_column :activities, :monday_closing_time, :time
    remove_column :activities, :tuesday_opening_time, :time
    remove_column :activities, :tuesday_closing_time, :time
    remove_column :activities, :wednesday_opening_time, :time
    remove_column :activities, :wednesday_closing_time, :time
    remove_column :activities, :thursday_opening_time, :time
    remove_column :activities, :thursday_closing_time, :time
    remove_column :activities, :friday_opening_time, :time
    remove_column :activities, :friday_closing_time, :time
    remove_column :activities, :saturday_opening_time, :time
    remove_column :activities, :saturday_closing_time, :time
    remove_column :activities, :sunday_opening_time, :time
    remove_column :activities, :sunday_closing_time, :time

    add_column :activities, :monday_opening_hours, :string
    add_column :activities, :tuesday_opening_hours, :string
    add_column :activities, :wednesday_opening_hours, :string
    add_column :activities, :thursday_opening_hours, :string
    add_column :activities, :friday_opening_hours, :string
    add_column :activities, :saturday_opening_hours, :string
    add_column :activities, :sunday_opening_hours, :string
  end
end
