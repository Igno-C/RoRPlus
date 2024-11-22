require "rails_helper"
require "parallel"
require "rake"

module Mutations
  RSpec.describe CreateQuote, type: :request do
    describe ".resolve" do
      
      tickers = ["ABC", "ABC", "ABc", "ga", "ge", "AbC"]
      timestamp = "2024-10-26T22:00:00Z"
      timestampt = "2024-10-26T22:00:0"
      price = 110
              
      it "Handles concurrent GraphQL requests to create and modify quotes" do
        expect do
          expect do
            Parallel.map(tickers.each_with_index.to_a, in_threads: 6) do |(ticker, index)|
              ActiveRecord::Base.connection_pool.with_connection do
                post "/graphql", params: {query: query(ticker, timestampt + index.to_s + 'Z', price)}
              end
            end
          end.to change {Quote.count}.by(6)
        end.to change {Ticker.count}.by(3)
      end

      it "Handles concurrent GraphQL requests to modify quotes" do
        expect do
          expect do
            Parallel.map(6.times.map.to_a, in_threads: 6) do |index|
              ActiveRecord::Base.connection_pool.with_connection do
                post "/graphql", params: {query: query("ABC", timestamp, price+index)}
              end
            end
          end.to change {Quote.count}.by(1)
        end.to change {Ticker.count}.by(1)
      end
    end

    def query(tic, tim, pri)
      <<~EOF
        mutation {
          createQuote(input:{
            ticker: "#{tic}",
            timestamp: "#{tim}",
            price: #{pri},
          }
          ) {
            quote {timestamp, price},
            errors,
          }
        }
      EOF
    end
  end
end
