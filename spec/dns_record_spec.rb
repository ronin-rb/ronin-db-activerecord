require 'spec_helper'
require 'ronin/db/dns_record'

describe Ronin::DB::DNSRecord do
  it "must use the 'ronin_dns_records' table" do
    expect(described_class.table_name).to eq('ronin_dns_records')
  end

  let(:ttl)   { 1800 }
  let(:value) { 'v=spf1 include:_spf.google.com ~all' }

  describe "validations" do
    it "must require a #ttl" do
      record = described_class.new(value: value)

      expect(record).to_not be_valid
      expect(record.errors[:ttl]).to eq(["can't be blank"])
    end

    it "must require a #value" do
      record = described_class.new(ttl: ttl)

      expect(record).to_not be_valid
      expect(record.errors[:value]).to eq(["can't be blank"])
    end

    it "must limit #value to a maximum length of 255" do
      record = described_class.new(value: 'A' * 256)

      expect(record).to_not be_valid
      expect(record.errors[:value]).to eq(["is too long (maximum is 255 characters)"])
    end
  end
end
