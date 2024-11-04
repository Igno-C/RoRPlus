require "rails_helper"

RSpec.describe Ticker, :type => :model do
  it "Is valid with a valid name" do
    t = Ticker.new(name: "ABC")
    expect(t).to be_valid
    expect {
      t.save
    }.to change {Ticker.count}.by(1)
  end

  it "Rejects ticker name with lowercase letter" do
    t = Ticker.new(name: "ABc")
    expect(t).to_not be_valid
    expect {
      t.save
    }.to change {Ticker.count}.by(0)
  end

  it "Rejects ticker name with non-letters" do
    t = Ticker.new(name: "A2C")
    expect(t).to_not be_valid
    expect {
      t.save
    }.to change {Ticker.count}.by(0)
  end

  it "Rejects empty ticker name" do
    t = Ticker.new(name: "A2C")
    expect(t).to_not be_valid
    expect {
      t.save
    }.to change {Ticker.count}.by(0)
  end

  it "Rejects too long ticker name" do
    t = Ticker.new(name: "ABCDE")
    expect(t).to_not be_valid
    expect {
      t.save
    }.to change {Ticker.count}.by(0)
  end

  it "Rejects nil ticker name" do
    t = Ticker.new(name: nil)
    expect(t).to_not be_valid
    expect {
      t.save
    }.to change {Ticker.count}.by(0)
  end
end
