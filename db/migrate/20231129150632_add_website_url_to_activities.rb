class AddWebsiteUrlToActivities < ActiveRecord::Migration[7.1]
  def change
    add_column :activities, :website_url, :string
  end
end
