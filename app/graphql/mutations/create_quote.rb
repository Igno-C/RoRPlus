# frozen_string_literal: true

class Mutations::CreateQuote < Mutations::BaseMutation
  argument :ticker, String, required: true
  argument :timestamp, GraphQL::Types::ISO8601DateTime, required: true
  argument :price, Int, required: true

  field :quote, Types::QuoteType, null: true
  field :errors, [String], null: false

  def resolve(ticker:, timestamp:, price:)
    # Checking if the ticker exists already
    t = Ticker.find_by(name: ticker.upcase)
    unless t
      # If not, create a new one
      t = Ticker.new(name: ticker.upcase)
      unless t
        # Didn't pass integrity checks
        return {
          quote: nil,
          errors: t.errors.full_messages
        }
      end
      unless t.save
        # Failed save
        return {
          quote: nil,
          errors: t.errors.full_messages
        }
      end
    end

    # Checking if need to update an existing quote
    existing_quote = t.quote.find_by(timestamp: timestamp)

    if existing_quote
      if existing_quote.update(price: price)
        # Successful update
        return {
          quote: existing_quote,
          errors: []
        }
      else
        # Failed update
        return {
          quote: nil,
          errors: existing_quote.errors.full_messages
        }
      end
    end

    # There is no existing quote to update => create new one
    new_quote = t.quote.new(timestamp: timestamp, price: price)
    unless new_quote
      # Didn't pass integrity checks
      return {
        quote: nil,
        errors: new_quote.errors.full_messages
      }
    end
    if new_quote.save
      # Successful save
      return {
        quote: new_quote,
        errors: []
      }
    else
      # Failed save
      return {
        quote: nil,
        errors: new_quote.errors.full_messages
      }
    end
  end
end
