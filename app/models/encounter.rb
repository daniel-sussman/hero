class Encounter < ApplicationRecord
  belongs_to :user
  belongs_to :activity
  has_many :collections, through: :encounter_collections
end
