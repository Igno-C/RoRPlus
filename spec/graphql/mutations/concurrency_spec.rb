require "rails_helper"
require "parallel"
require "rake"

module Mutations
  RSpec.describe CreateQuote, type: :request do
    describe ".resolve" do
      
      tickers = ["ABC", "ABC", "ABc", "ga", "ge", "AbC"]

      it "Handles concurrent GraphQL requests to create and modify quotes" do
        expect do
          expect do
            ActiveRecord::Base.connection_pool.disconnect!
            Parallel.map(tickers.each_with_index.to_a, in_processes: 6) do |(ticker, index)|
              ActiveRecord::Base.connection_pool.with_connection do
                post "/graphql", params: {query: query(ticker, "2024-10-26T22:00:0" + index.to_s + "Z", 100 + index)}
              end
            end
          end.to change {Quote.count}.by(6)
        end.to change {Ticker.count}.by(3)
      end

      it "Handles concurrent GraphQL requests to modify quotes" do
        expect do
          expect do
            ActiveRecord::Base.connection_pool.disconnect!
            Parallel.map(6.times.map.to_a, in_processes: 6) do |index|
              ActiveRecord::Base.connection_pool.with_connection do
                post "/graphql", params: {query: query("ABC", "2024-10-26T22:00:00Z", 100+index)}
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
