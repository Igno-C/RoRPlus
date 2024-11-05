require "rails_helper"

module Mutations
  RSpec.describe CreateQuote, type: :request do
    describe ".resolve" do

      ticker = "TeSt"
      timestamp = "2024-10-26T22:00:00Z"
      price = 110

      resp = nil # Used to store the response between subtests

      it "Creates a quote" do
        expect do
          expect do
            post "/graphql", params: {query: query(ticker, timestamp, price)}
            resp = response.body
          end.to change {Quote.count}.by(1)
        end.to change {Ticker.count}.by(1)
      end

      it "Returns the inserted quote" do
        data = JSON.parse(resp)
        data = data["data"]["createQuote"]["quote"]

        expect(data).to include(
          "timestamp" => "2024-10-26T22:00:00Z",
          "price" => price
        )
      end

      it "Modifies the quote instead of inserting" do
        expect do
          expect do
            post "/graphql", params: {query: query(ticker, timestamp, price)}
            post "/graphql", params: {query: query(ticker, timestamp, price+10)}
            resp = response.body
          end.to change {Quote.count}.by(1)
        end.to change {Ticker.count}.by(1)
      end

      it "Returns the updated value" do
        data = JSON.parse(resp)
        data = data["data"]["createQuote"]["quote"]

        expect(data).to include(
          "price" => price+10
        )
      end

      it "Creates only one Ticker object" do
        expect do
          expect do
            post "/graphql", params: {query: query(ticker, "2024-10-26T22:00:00Z", price)}
            post "/graphql", params: {query: query(ticker, "2024-10-26T23:00:00Z", price)}
            post "/graphql", params: {query: query(ticker, "2024-10-26T24:00:00Z", price)}
          end.to change {Quote.count}.by(3)
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
