require "spec_helper"

RSpec.describe Sysrandom do
  it "has a version number" do
    expect(Sysrandom::VERSION).not_to be nil
  end

  describe ".random_number" do
    it "creates floats between 0..1 if no argument is given" do
      n = described_class.random_number
      expect(n).to be_a Float
      expect(n).to be > 0
      expect(n).to be < 1
    end

    it "returns an Integer if given an Integer as an argument" do
      expect(described_class.random_number(42)).to be_an Integer
    end

    it "returns a Float if given a Float as an argument" do
      expect(described_class.random_number(42.0)).to be_a Float
    end
  end

  describe ".random_bytes" do
    it "creates strings with random bytes" do
      string = described_class.random_bytes
      expect(string).to be_a String

      string2 = described_class.random_bytes
      expect(string).to_not eq string2 # randomness is hard to test for
    end

    it "honors its length argument" do
      expect(described_class.random_bytes(42).size).to eq 42
    end

    it "allows nil as a length argument" do
      expect(described_class.random_bytes(nil).size).to eq 16
    end

    # SecureRandom's wacky default string size
    it "creates strings of length 16 by default" do
      expect(described_class.random_bytes.size).to eq 16
    end

    it "returns an empty string if zero bytes requested" do
      expect(described_class.random_bytes(0)).to eq ""
    end

    it "generates a random binary string of specified length" do
      (1..64).each do |idx|
        bytes = described_class.random_bytes(idx)
        expect(bytes).to be_a String
        expect(bytes.size).to eq idx
      end

      expect(described_class.random_bytes(2.2).length).to eq(2)
    end

    it "generates different binary strings with subsequent invocations" do
      # quick and dirty check, but good enough
      values = []
      256.times do
        val = described_class.random_bytes
        # make sure the random bytes are not repeating
        expect(values.include?(val)).to be(false)
        values << val
      end
    end

    it "raises ArgumentError on negative arguments" do
      expect { described_class.random_bytes(-1) }.to raise_error(ArgumentError, "negative string size")
    end

    it "calls to_int on the number passed as an arg" do
      # jruby doesn't do this test
      unless defined? JRUBY_VERSION
        obj = double("to_int")
        expect(obj).to receive(:to_int) { 5 }
        expect(described_class.random_bytes(obj).size).to eq(5)
      end
    end
  end

  describe ".base64" do
    it "creates random base64 strings" do
      base64 = described_class.base64(16)
      expect(Base64.decode64(base64)).to be_a String
    end
  end

  describe ".hex" do
    it "creates random hexadecimal strings" do
      hex = described_class.hex(16)
      expect([hex].pack("h*")).to be_a String
    end
  end

  describe ".urlsafe_base64" do
    it "creates unpadded strings by default" do
      expect(described_class.urlsafe_base64).not_to include("=")
    end

    it "optionally creates padded strings" do
      expect(described_class.urlsafe_base64(nil, true)).to include("=")
    end

    it "creates valid urlsafe_base64 strings" do
      base64 = described_class.urlsafe_base64(nil, true)
      expect(Base64.urlsafe_decode64(base64)).to be_a String
    end
  end

  describe ".uuid" do
    it "creates random UUIDs" do
      uuid = described_class.uuid
      expect(uuid).to match(/[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89ab][a-f0-9]{3}-[a-f0-9]{12}/)
    end
  end
end
