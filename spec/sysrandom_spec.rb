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

    it "returns a Fixnum if given a Fixnum as an argument" do
      expect(described_class.random_number(42)).to be_a Fixnum
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

    # SecureRandom's wacky default string size
    it "creates strings of length 16 by default" do
      expect(described_class.random_bytes.size).to eq 16 
    end

    # SecureRandom compatibility
    it "returns an empty string when given a length of 0" do
      expect(described_class.random_bytes(0)).to be_empty
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
    it "creates random urlsafe_base64 strings" do
      base64 = described_class.urlsafe_base64(16)
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
