class ActivityCategory < ApplicationRecord
  belongs_to :activity
  belongs_to :category

  validates :activity, uniqueness: { scope: :category }
end
