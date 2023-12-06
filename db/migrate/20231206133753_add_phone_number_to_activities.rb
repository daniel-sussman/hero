class AddPhoneNumberToActivities < ActiveRecord::Migration[7.1]
  def change
    add_column :activities, :phone_number, :string
  end
end
