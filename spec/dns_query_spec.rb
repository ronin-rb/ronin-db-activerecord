require 'spec_helper'
require 'ronin/db/dns_query'

describe Ronin::DB::DNSQuery do
  it "must use the 'ronin_dns_queries' table" do
    expect(described_class.table_name).to eq('ronin_dns_queries')
  end

  let(:type)        { :a }
  let(:label)       { 'example.com' }
  let(:source_addr) { '192.168.1.1' }

  subject do
    described_class.new(
      type:        type,
      label:       label,
      source_addr: source_addr
    )
  end

  describe "validations" do
    it "must require a type" do
      dns_query = described_class.new(label: label, source_addr: source_addr)

      expect(dns_query).to_not be_valid

      dns_query = described_class.new(
        type:        type,
        label:       label,
        source_addr: source_addr
      )

      expect(dns_query).to be_valid
    end

    it "must require a label" do
      dns_query = described_class.new(type: type, source_addr: source_addr)

      expect(dns_query).to_not be_valid

      dns_query = described_class.new(
        type:        type,
        label:       label,
        source_addr: source_addr
      )

      expect(dns_query).to be_valid
    end

    it "must require a source_addr" do
      dns_query = described_class.new(type: type, label: label)

      expect(dns_query).to_not be_valid

      dns_query = described_class.new(
        type:        type,
        label:       label,
        source_addr: source_addr
      )

      expect(dns_query).to be_valid
    end

    describe "type" do
      [
        :a,
        :aaaa,
        :any,
        :cname,
        :hinfo,
        :loc,
        :mx,
        :ns,
        :ptr,
        :soa,
        :srv,
        :txt,
        :wks
      ].each do |valid_type|
        it "must accept #{valid_type.inspect}" do
          dns_query = described_class.new(
            type:        valid_type,
            label:       label,
            source_addr: source_addr
          )

          expect(dns_query).to be_valid
        end
      end

      context "otherwise" do
        it "must not accept other values" do
          expect {
            described_class.new(
              type:        :other,
              label:       label,
              source_addr: source_addr
            )
          }.to raise_error(ArgumentError,"'other' is not a valid type")
        end
      end
    end

    describe "source_addr" do
      it "must accept IPv4 addresses" do
        dns_query = described_class.new(
          type:        type,
          label:       label,
          source_addr: '192.168.1.1'
        )

        expect(dns_query).to be_valid
      end

      it "must accept IPv6 addresses" do
        dns_query = described_class.new(
          type:        type,
          label:       label,
          source_addr: '2600:1408:ec00:36::1736:7f31'
        )

        expect(dns_query).to be_valid
      end
    end
  end
end
