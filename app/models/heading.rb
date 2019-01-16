class Heading < ApplicationRecord
  has_many :materials

  validates :slug, uniqueness: true
  validates :title, :slug, presence: true
end
