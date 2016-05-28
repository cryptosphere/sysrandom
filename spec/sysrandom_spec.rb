require "spec_helper"

RSpec.describe Sysrandom do
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
end
