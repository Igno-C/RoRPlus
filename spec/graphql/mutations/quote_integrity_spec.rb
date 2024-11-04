require "rails_helper"

module Mutations
  module QuoteTests
    RSpec.describe CreateQuote, type: :request do
      describe ".resolve" do

        ticker = "TeSt"
        timestamp = "2024-10-26T22:00:00Z"
        price = 110

        it "Rejects non-alphabet tickers" do
          expect do
            post "/graphql", params: {query: query("te1", timestamp, price)}
            resp = response.body
            json = JSON.parse(resp)
            expect(json["data"]["createQuote"]["errors"].length).to be > 0
          end.to change {Quote.count}.by(0)
        end

        it "Rejects negative prices" do
          expect do
            post "/graphql", params: {query: query(ticker, timestamp, -23)}
            resp = response.body
            json = JSON.parse(resp)
            expect(json["data"]["createQuote"]["errors"].length).to be > 0
          end.to change {Quote.count}.by(0)
        end

        it "Rejects empty ticker" do
          expect do
            post "/graphql", params: {query: query("", timestamp, price)}
            resp = response.body
            json = JSON.parse(resp)
            expect(json["data"]["createQuote"]["errors"].length).to be > 0
          end.to change {Quote.count}.by(0)
        end
        it "Rejects long ticker" do
          expect do
            post "/graphql", params: {query: query("AAAAA", timestamp, price)}
            resp = response.body
            json = JSON.parse(resp)
            expect(json["data"]["createQuote"]["errors"].length).to be > 0
          end.to change {Quote.count}.by(0)
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
end
