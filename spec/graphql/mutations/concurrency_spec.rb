require "rails_helper"
require "concurrent"

module Mutations
  RSpec.describe CreateQuote, type: :request do
    describe ".resolve" do
      
      tickers = ["TeSt", "ABC", "rra", "ga", "ge"]
      timestamp = "2024-10-26T22:00:00Z"
      price = 110
              
      it "Handles concurrent GraphQL requests to create quotes" do
        expect do
          expect do
            tickers.map do |ticker|
              Thread.new do
                post "/graphql", params: {query: query(ticker, timestamp, price)}
              end
            end.each(&:join)
          end.to change {Quote.count}.by(tickers.length)
        end.to change {Ticker.count}.by(tickers.length)
      end

      it "Handles concurrent GraphQL requests to modify quotes" do
        expect do
          expect do
            5.times.map do |i|
              Thread.new do
                post "/graphql", params: {query: query("ABC", timestamp, price)}
              end
            end.each(&:join)
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
