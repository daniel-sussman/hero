class Category < ApplicationRecord
  has_many :activities, through: :activity_categories
  has_many :users, through: :user_categories
end
