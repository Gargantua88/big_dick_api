class Tag < ApplicationRecord
  has_and_belongs_to_many :materials

  validates :slug, uniqueness: true
  validates :title, :slug, presence: true
end
