class Material < ApplicationRecord
  belongs_to :heading, optional: true, autosave: true
  has_and_belongs_to_many :tags, autosave: true

  # Все поля - обязательные по ТЗ
  validates :title, :announcement, :cover_url, :body, :link, :published_date, presence: true

  # Для получения материала по ссылке удостоверимся, что она уникальна
  validates :link, uniqueness: true
end
