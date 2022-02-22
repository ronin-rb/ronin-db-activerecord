require 'spec_helper'
require 'ronin/db/os_guess'

describe Ronin::DB::OSGuess do
  it "must use the 'ronin_os_guesses' table" do
    expect(described_class.table_name).to eq('ronin_os_guesses')
  end

  let(:address)    { '127.0.0.1' }
  let(:ip_address) { Ronin::DB::IPAddress.new(address: address) }

  let(:os_name)    { 'Windows' }
  let(:os_version) { '10'      }
  let(:os)         { Ronin::DB::OS.new(name: os_name, version: os_version) }

  describe "validations" do
    describe "ip_address" do
      it "must require an ip_address" do
        os_guess = described_class.new(os: os)
        expect(os_guess).to_not be_valid
        expect(os_guess.errors[:ip_address]).to eq(
          ["must exist"]
        )

        os_guess = described_class.new(os: os, ip_address: ip_address)
        expect(os_guess).to be_valid
      end
    end

    describe "os" do
      it "must require an os" do
        os_guess = described_class.new(ip_address: ip_address)
        expect(os_guess).to_not be_valid
        expect(os_guess.errors[:os]).to eq(
          ["must exist"]
        )

        os_guess = described_class.new(os: os, ip_address: ip_address)
        expect(os_guess).to be_valid
      end
    end
  end
end
