require "rails_helper"

RSpec.describe Quote, :type => :model do
  # Example date and ticker that can be reused
  d = DateTime.civil_from_format(:utc, 2024, 11, 4)
  t = Ticker.new(name: "ABC")

  it "Is valid with valid data and ticker" do
    t.save
    q = t.quote.new(timestamp: d, price: 100)
    expect(q).to be_valid
    expect {
      q.save
    }.to change {Quote.count}.by(1)
  end

  it "Rejects without valid ticker reference" do
    q = Quote.new(timestamp: d, price: 100)
    expect(q).to_not be_valid
    expect {
      q.save
    }.to change {Quote.count}.by(0)
  end

  it "Rejects quote with negative price" do
    t.save
    q = t.quote.new(timestamp: d, price: -100)
    expect(q).to_not be_valid
    expect {
      q.save
    }.to change {Ticker.count}.by(0)
  end

  it "Rejects quote with nil price" do
    t.save
    q = t.quote.new(timestamp: d, price: nil)
    expect(q).to_not be_valid
    expect {
      q.save
    }.to change {Ticker.count}.by(0)
  end

  it "Rejects quote with nil timestamp" do
    t.save
    q = t.quote.new(timestamp: nil, price: 100)
    expect(q).to_not be_valid
    expect {
      q.save
    }.to change {Ticker.count}.by(0)
  end
end
