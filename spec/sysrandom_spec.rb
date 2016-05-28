require "spec_helper"

RSpec.describe Sysrandom do
  describe ".random_bytes" do
    it "creates random bytes" do
      string = described_class.random_bytes
      expect(string).to be_a String

      string2 = described_class.random_bytes
      expect(string).to_not eq string2 # randomness is hard to test for
    end

    it "creates strings of length 16 by default" do
      expect(described_class.random_bytes.size).to eq 16 # SecureRandom's wacky default string size
    end

    it "honors its length argument" do
      expect(described_class.random_bytes(42).size).to eq 42
    end
  end
end
