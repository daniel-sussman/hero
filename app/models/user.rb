class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :children, dependent: :destroy
  has_many :collections, dependent: :destroy
  has_many :encounters, dependent: :destroy
  has_many :activities, through: :encounters
  has_many :user_categories, dependent: :destroy
  has_many :categories, through: :user_categories

  accepts_nested_attributes_for :children
  geocoded_by :address, params: { country: 'gb', proximity: '51.508045,-0.128217' }
  after_validation :geocode, if: :will_save_change_to_address?

  validates :name, :address, presence: true
end
