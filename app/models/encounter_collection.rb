class EncounterCollection < ApplicationRecord
  belongs_to :collection
  belongs_to :encounter
  has_many :activities, through: :encounters
  has_many :users, through: :encounters
end
