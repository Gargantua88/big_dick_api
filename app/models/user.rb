class User < ApplicationRecord
  before_validation :generate_token, on: :create

  validates :token, presence: true

  private

  def generate_token
   self.token ||= SecureRandom.alphanumeric(20)
  end
end
