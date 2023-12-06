class Encounter < ApplicationRecord
  belongs_to :user
  belongs_to :activity
  has_many :collections, through: :encounter_collections

  validates :user_id, uniqueness: { scope: :activity_id }
end
