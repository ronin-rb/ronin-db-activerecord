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

  describe "#a_query?" do
    context "when #type is :a" do
      let(:type) { :a }

      it "must return true" do
        expect(subject.a_query?).to be(true)
      end
    end

    context "when #type is not :a" do
      let(:type) { :wks }

      it "must return false" do
        expect(subject.a_query?).to be(false)
      end
    end
  end

  describe "#aaaa_query?" do
    context "when #type is :aaaa" do
      let(:type) { :aaaa }

      it "must return true" do
        expect(subject.aaaa_query?).to be(true)
      end
    end

    context "when #type is not :aaaa" do
      let(:type) { :wks }

      it "must return false" do
        expect(subject.aaaa_query?).to be(false)
      end
    end
  end

  describe "#any_query?" do
    context "when #type is :any" do
      let(:type) { :any }

      it "must return true" do
        expect(subject.any_query?).to be(true)
      end
    end

    context "when #type is not :any" do
      let(:type) { :wks }

      it "must return false" do
        expect(subject.any_query?).to be(false)
      end
    end
  end

  describe "#cname_query?" do
    context "when #type is :cname" do
      let(:type) { :cname }

      it "must return true" do
        expect(subject.cname_query?).to be(true)
      end
    end

    context "when #type is not :cname" do
      let(:type) { :wks }

      it "must return false" do
        expect(subject.cname_query?).to be(false)
      end
    end
  end

  describe "#hinfo_query?" do
    context "when #type is :hinfo" do
      let(:type) { :hinfo }

      it "must return true" do
        expect(subject.hinfo_query?).to be(true)
      end
    end

    context "when #type is not :hinfo" do
      let(:type) { :wks }

      it "must return false" do
        expect(subject.hinfo_query?).to be(false)
      end
    end
  end

  describe "#loc_query?" do
    context "when #type is :loc" do
      let(:type) { :loc }

      it "must return true" do
        expect(subject.loc_query?).to be(true)
      end
    end

    context "when #type is not :loc" do
      let(:type) { :wks }

      it "must return false" do
        expect(subject.loc_query?).to be(false)
      end
    end
  end

  describe "#mx_query?" do
    context "when #type is :mx" do
      let(:type) { :mx }

      it "must return true" do
        expect(subject.mx_query?).to be(true)
      end
    end

    context "when #type is not :mx" do
      let(:type) { :wks }

      it "must return false" do
        expect(subject.mx_query?).to be(false)
      end
    end
  end

  describe "#ns_query?" do
    context "when #type is :ns" do
      let(:type) { :ns }

      it "must return true" do
        expect(subject.ns_query?).to be(true)
      end
    end

    context "when #type is not :ns" do
      let(:type) { :wks }

      it "must return false" do
        expect(subject.ns_query?).to be(false)
      end
    end
  end

  describe "#ptr_query?" do
    context "when #type is :ptr" do
      let(:type) { :ptr }

      it "must return true" do
        expect(subject.ptr_query?).to be(true)
      end
    end

    context "when #type is not :ptr" do
      let(:type) { :wks }

      it "must return false" do
        expect(subject.ptr_query?).to be(false)
      end
    end
  end

  describe "#soa_query?" do
    context "when #type is :soa" do
      let(:type) { :soa }

      it "must return true" do
        expect(subject.soa_query?).to be(true)
      end
    end

    context "when #type is not :soa" do
      let(:type) { :wks }

      it "must return false" do
        expect(subject.soa_query?).to be(false)
      end
    end
  end

  describe "#srv_query?" do
    context "when #type is :srv" do
      let(:type) { :srv }

      it "must return true" do
        expect(subject.srv_query?).to be(true)
      end
    end

    context "when #type is not :srv" do
      let(:type) { :wks }

      it "must return false" do
        expect(subject.srv_query?).to be(false)
      end
    end
  end

  describe "#txt_query?" do
    context "when #type is :txt" do
      let(:type) { :txt }

      it "must return true" do
        expect(subject.txt_query?).to be(true)
      end
    end

    context "when #type is not :txt" do
      let(:type) { :wks }

      it "must return false" do
        expect(subject.txt_query?).to be(false)
      end
    end
  end

  describe "#wks_query?" do
    context "when #type is :wks" do
      let(:type) { :wks }

      it "must return true" do
        expect(subject.wks_query?).to be(true)
      end
    end

    context "when #type is not :wks" do
      let(:type) { :a }

      it "must return false" do
        expect(subject.wks_query?).to be(false)
      end
    end
  end
end
