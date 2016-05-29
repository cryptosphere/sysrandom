require "spec_helper"

RSpec.describe "sysrandom/securerandom" do
  it "patches SecureRandom to be Sysrandom when loaded" do
    require "securerandom"
    expect(SecureRandom).not_to eq Sysrandom

    require "sysrandom/securerandom"
    expect(SecureRandom).to eq Sysrandom
  end
end
