require "rails_helper"

module Types
  module QuoteTests
    RSpec.describe QueryType, type: :request do
      describe ".all_quotes" do
        it "Returns empty list for bad ticker" do
          t1 = Ticker.new(name: "ABC")
          t2 = Ticker.new(name: "AB")
          t1.save; t2.save
          t1.quote.new(timestamp: "2024-01-02", price: 100).save
          t1.quote.new(timestamp: "2024-01-03", price: 120).save
          t2.quote.new(timestamp: "2024-01-02", price: 110).save

          post "/graphql", params: {query: query("allQuotes", "A")}
          json = JSON.parse(response.body)
          expect(json["data"]["allQuotes"].size).to eq(0)
        end

        it "Returns list of quotes for given ticker" do
          t1 = Ticker.new(name: "ABC")
          t2 = Ticker.new(name: "AB")
          t1.save; t2.save
          t1.quote.new(timestamp: "2024-01-02", price: 100).save
          t1.quote.new(timestamp: "2024-01-03", price: 120).save
          t2.quote.new(timestamp: "2024-01-02", price: 110).save

          post "/graphql", params: {query: query("allQuotes", "ABC")}
          json = JSON.parse(response.body)
          expect(json["data"]["allQuotes"][0]["price"]).to eq(100)
          expect(json["data"]["allQuotes"][1]["price"]).to eq(120)
        end
      end

      describe ".latest_quote" do
        it "Returns null data for bad ticker" do
          t1 = Ticker.new(name: "ABC")
          t2 = Ticker.new(name: "AB")
          t1.save; t2.save
          t1.quote.new(timestamp: "2024-01-02", price: 100).save
          t1.quote.new(timestamp: "2024-01-03", price: 120).save
          t2.quote.new(timestamp: "2024-01-02", price: 110).save

          post "/graphql", params: {query: query("latestQuote", "A")}
          json = JSON.parse(response.body)
          expect(json["data"]["latestQuote"]).to be_nil
        end

        it "Returns newest quote for given ticker" do
          t1 = Ticker.new(name: "ABC")
          t2 = Ticker.new(name: "AB")
          t1.save; t2.save
          t1.quote.new(timestamp: "2024-01-02", price: 100).save
          t1.quote.new(timestamp: "2024-01-03", price: 120).save
          t2.quote.new(timestamp: "2024-01-02", price: 110).save

          post "/graphql", params: {query: query("latestQuote", "ABC")}
          json = JSON.parse(response.body)
          expect(json["data"]["latestQuote"]["price"]).to eq(120)
        end
      end
      
      def query(kind, tic)
        <<~EOF
          query {
            #{kind}(ticker: "#{tic}") {price, timestamp}
          }
        EOF
      end
    end
  end
end
