class Activity < ApplicationRecord
  has_many :activity_categories, dependent: :destroy
  has_many :categories, through: :activity_categories
  has_many :encounters, dependent: :destroy
  has_many :users, through: :encounters
end
