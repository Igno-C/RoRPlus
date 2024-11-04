# frozen_string_literal: true

module Types
  class QuoteType < Types::BaseObject
    #implements Types::RecordType
    description 'A stock quote'
    
    field :timestamp, GraphQL::Types::ISO8601DateTime, null: false, description: 'The transaction\'s timestamp.'
    field :price, Int, null: false, description: 'Price of the instrument.'
  end
end
