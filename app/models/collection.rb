class Collection < ApplicationRecord
  belongs_to :user
  has_many :encounter_collections, dependent: :destroy
  has_many :encounters, through: :encounter_collections

  validates :title, presence: true

  def activity
    encounter.activity
  end
end
