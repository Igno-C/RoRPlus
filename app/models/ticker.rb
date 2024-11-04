class Ticker < ApplicationRecord
  has_many :quote

  # The string being nonempty is already getting checked for
  validates :name, presence: true, length: {maximum: 4}, format: {with: /\A[A-Z]+\z/}
end
