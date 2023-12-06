class Activity < ApplicationRecord
  geocoded_by :address, params: { country: 'gb', proximity: '51.508045,-0.128217' }
  after_validation :geocode, if: :will_save_change_to_address?
  before_destroy :purge_photos

  has_many :activity_categories, dependent: :destroy
  has_many :categories, through: :activity_categories
  has_many :encounters, dependent: :destroy
  has_many :users, through: :encounters

  has_one_attached :photo

  validates :title, uniqueness: true

  def reviews
    encounters.find {|encounter| encounter.review.present?} || []
  end

  def purge_photos
    self.photo.purge
  end

  def color_code
    #to-do: color code by category
    "green"
  end

  def self.algorithm_sort(user)
    return all unless user

    activities_hash = {}

    all.each do |activity|
      activity_score = activity.distance_from(user)
      unless activity.photo.present?
        activity_score += 6.5
      end
      encounter_exists = Encounter.find_by(activity_id: activity.id, user_id: user.id)
      if encounter_exists
        encounter_exists.liked || encounter_exists.saved ? activity_score += 2 : activity_score += 5
      end
      activities_hash[activity.id] = activity_score
    end

    all.sort_by { |activity| activities_hash[activity.id] }
  end
end
