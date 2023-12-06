class EncounterCollection < ApplicationRecord
  belongs_to :collection
  belongs_to :encounter
  has_many :activities, through: :encounters
  has_many :users, through: :encounters

  validates :collection_id, uniqueness: { scope: :encounter_id }
end
