class Quote < ApplicationRecord
  belongs_to :ticker

  validates :timestamp, presence: true
  validates :price, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :timestamp, uniqueness: { scope: :ticker_id }
end
