class Ticker < ApplicationRecord
  has_many :quote

  validates :name, presence: true, length: {maximum: 4, minimum: 1}
end
