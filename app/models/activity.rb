class Activity < ApplicationRecord
  geocoded_by :address, params: { country: 'gb', proximity: '51.508045,-0.128217' }
  after_validation :geocode, if: :will_save_change_to_address?

  has_many :activity_categories, dependent: :destroy
  has_many :categories, through: :activity_categories
  has_many :encounters, dependent: :destroy
  has_many :users, through: :encounters

  has_one_attached :photo
end
