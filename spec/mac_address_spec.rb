require 'spec_helper'

require 'ronin/db/mac_address'

describe Ronin::DB::MACAddress do
  it "must use the 'ronin_mac_addresses' table" do
    expect(described_class.table_name).to eq('ronin_mac_addresses')
  end

  let(:address) { '00:01:02:03:04:05' }

  subject { described_class.new(address: address) }

  describe "validations" do
    describe "address" do
      it "should require an address" do
        mac_address = described_class.new
        expect(mac_address).not_to be_valid
        expect(mac_address.errors[:address]).to include(
          "can't be blank"
        )

        mac_address = described_class.new(address: address)
        expect(mac_address).to be_valid
      end
    end
  end

  describe "#recent_ip_address" do
  end

  describe "#to_i" do
    let(:integer) { 0x000102030405 }

    it "should convert the MAC Address to an Integer" do
      expect(subject.to_i).to eq(integer)
    end
  end
end
