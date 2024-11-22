# frozen_string_literal: true

class Mutations::CreateQuote < Mutations::BaseMutation
  argument :ticker, String, required: true
  argument :timestamp, GraphQL::Types::ISO8601DateTime, required: true
  argument :price, Int, required: true

  field :quote, Types::QuoteType, null: true
  field :errors, [String], null: false

  def resolve(ticker:, timestamp:, price:)
    begin
      quote = ActiveRecord::Base.transaction do
        ticker = Ticker.lock.find_or_create_by!(name: ticker.upcase)

        existing_quote = ticker.quote.lock.find_by(timestamp: timestamp)
        if existing_quote
          existing_quote.update!(price: price)
          existing_quote
        else
          ticker.quote.create!(timestamp: timestamp, price: price)
        end
      end
      {quote: quote, errors: []}
    rescue ActiveRecord::RecordNotUnique
      retry
    rescue => e
      {quote: nil, errors: [e.message]}
    end
  end
end
