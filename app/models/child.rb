class Child < ApplicationRecord
  belongs_to :user

  validates :birthday, presence: true
end
