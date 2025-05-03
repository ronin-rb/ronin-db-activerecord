require 'spec_helper'
require 'ronin/db/dns_query'

describe Ronin::DB::DNSQuery do
  it "must use the 'ronin_dns_queries' table" do
    expect(described_class.table_name).to eq('ronin_dns_queries')
  end

  let(:type)        { 'A' }
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
      %w[
        A
        AAAA
        ANY
        CNAME
        HINFO
        LOC
        MX
        NS
        PTR
        SOA
        SRV
        TXT
        WKS
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

      it "must not accept other values" do
        dns_query = described_class.new(
          type:        'OTHER',
          label:       label,
          source_addr: source_addr
        )

        expect(dns_query).to_not be_valid
        expect(dns_query.errors[:type]).to eq(['is not included in the list'])
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

  describe "#a_query?" do
    context "when #type is :a" do
      let(:type) { 'A' }

      it "must return true" do
        expect(subject.a_query?).to be(true)
      end
    end

    context "when #type is not :a" do
      let(:type) { 'WKS' }

      it "must return false" do
        expect(subject.a_query?).to be(false)
      end
    end
  end

  describe "#aaaa_query?" do
    context "when #type is :aaaa" do
      let(:type) { 'AAAA' }

      it "must return true" do
        expect(subject.aaaa_query?).to be(true)
      end
    end

    context "when #type is not :aaaa" do
      let(:type) { 'WKS' }

      it "must return false" do
        expect(subject.aaaa_query?).to be(false)
      end
    end
  end

  describe "#any_query?" do
    context "when #type is :any" do
      let(:type) { 'ANY' }

      it "must return true" do
        expect(subject.any_query?).to be(true)
      end
    end

    context "when #type is not :any" do
      let(:type) { 'WKS' }

      it "must return false" do
        expect(subject.any_query?).to be(false)
      end
    end
  end

  describe "#cname_query?" do
    context "when #type is :cname" do
      let(:type) { 'CNAME' }

      it "must return true" do
        expect(subject.cname_query?).to be(true)
      end
    end

    context "when #type is not :cname" do
      let(:type) { 'WKS' }

      it "must return false" do
        expect(subject.cname_query?).to be(false)
      end
    end
  end

  describe "#hinfo_query?" do
    context "when #type is :hinfo" do
      let(:type) { 'HINFO' }

      it "must return true" do
        expect(subject.hinfo_query?).to be(true)
      end
    end

    context "when #type is not :hinfo" do
      let(:type) { 'WKS' }

      it "must return false" do
        expect(subject.hinfo_query?).to be(false)
      end
    end
  end

  describe "#loc_query?" do
    context "when #type is :loc" do
      let(:type) { 'LOC' }

      it "must return true" do
        expect(subject.loc_query?).to be(true)
      end
    end

    context "when #type is not :loc" do
      let(:type) { 'WKS' }

      it "must return false" do
        expect(subject.loc_query?).to be(false)
      end
    end
  end

  describe "#mx_query?" do
    context "when #type is :mx" do
      let(:type) { 'MX' }

      it "must return true" do
        expect(subject.mx_query?).to be(true)
      end
    end

    context "when #type is not :mx" do
      let(:type) { 'WKS' }

      it "must return false" do
        expect(subject.mx_query?).to be(false)
      end
    end
  end

  describe "#ns_query?" do
    context "when #type is :ns" do
      let(:type) { 'NS' }

      it "must return true" do
        expect(subject.ns_query?).to be(true)
      end
    end

    context "when #type is not :ns" do
      let(:type) { 'WKS' }

      it "must return false" do
        expect(subject.ns_query?).to be(false)
      end
    end
  end

  describe "#ptr_query?" do
    context "when #type is :ptr" do
      let(:type) { 'PTR' }

      it "must return true" do
        expect(subject.ptr_query?).to be(true)
      end
    end

    context "when #type is not :ptr" do
      let(:type) { 'WKS' }

      it "must return false" do
        expect(subject.ptr_query?).to be(false)
      end
    end
  end

  describe "#soa_query?" do
    context "when #type is :soa" do
      let(:type) { 'SOA' }

      it "must return true" do
        expect(subject.soa_query?).to be(true)
      end
    end

    context "when #type is not :soa" do
      let(:type) { 'WKS' }

      it "must return false" do
        expect(subject.soa_query?).to be(false)
      end
    end
  end

  describe "#srv_query?" do
    context "when #type is :srv" do
      let(:type) { 'SRV' }

      it "must return true" do
        expect(subject.srv_query?).to be(true)
      end
    end

    context "when #type is not :srv" do
      let(:type) { 'WKS' }

      it "must return false" do
        expect(subject.srv_query?).to be(false)
      end
    end
  end

  describe "#txt_query?" do
    context "when #type is :txt" do
      let(:type) { 'TXT' }

      it "must return true" do
        expect(subject.txt_query?).to be(true)
      end
    end

    context "when #type is not :txt" do
      let(:type) { 'WKS' }

      it "must return false" do
        expect(subject.txt_query?).to be(false)
      end
    end
  end

  describe "#wks_query?" do
    context "when #type is :wks" do
      let(:type) { 'WKS' }

      it "must return true" do
        expect(subject.wks_query?).to be(true)
      end
    end

    context "when #type is not :wks" do
      let(:type) { 'A' }

      it "must return false" do
        expect(subject.wks_query?).to be(false)
      end
    end
  end
end
