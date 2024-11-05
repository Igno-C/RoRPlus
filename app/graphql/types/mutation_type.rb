# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_quote, mutation: Mutations::CreateQuote, description: "Create a new quote in the database."
  end
end
