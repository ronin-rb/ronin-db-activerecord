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
      it "must require an address" do
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

  describe ".lookup" do
    before do
      described_class.create(address: '11:12:13:14:15:16')
      described_class.create(address: address)
      described_class.create(address: '21:22:23:24:25:26')
    end

    it "must query the #{described_class} with the matching MAC address" do
      ip_address = described_class.lookup(address)

      expect(ip_address).to be_kind_of(described_class)
      expect(ip_address.address).to eq(address)
    end

    after { described_class.destroy_all }
  end

  describe ".import" do
    subject { described_class.import(address) }

    it "must parse and import the MAC address and set #address" do
      expect(subject).to be_kind_of(described_class)
      expect(subject.id).to_not be(nil)
      expect(subject.address).to eq(address)
    end

    after { described_class.destroy_all }
  end

  describe "#recent_ip_address"

  describe "#to_i" do
    let(:integer) { 0x000102030405 }

    it "must convert the MAC Address to an Integer" do
      expect(subject.to_i).to eq(integer)
    end
  end
end
