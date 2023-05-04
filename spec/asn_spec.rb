require 'spec_helper'
require 'ronin/db/asn'

describe Ronin::DB::ASN do
  it "must use the 'ronin_asns' table" do
    expect(described_class.table_name).to eq('ronin_asns')
  end

  let(:version)      { 4 }
  let(:range_start)  { '4.0.0.0' }
  let(:range_end)    { '4.7.168.255' }
  let(:number)       { 3356 }
  let(:country_code) { 'US' }
  let(:name)         { 'LEVEL3' }

  describe "validations" do
    describe "version" do
      it "must require a version" do
        asn = described_class.new(
          range_start:  range_start,
          range_end:    range_end,
          number:       number,
          country_code: country_code,
          name:         name
        )

        expect(asn).to_not be_valid
        expect(asn.errors[:version]).to eq(
          ["can't be blank", "is not included in the list"]
        )
      end

      it "must accept a value of 4" do
        asn = described_class.new(
          version:      4,
          range_start:  range_start,
          range_end:    range_end,
          number:       number,
          country_code: country_code,
          name:         name
        )

        expect(asn).to be_valid
      end

      it "must accept a value of 6" do
        asn = described_class.new(
          version:      6,
          range_start:  range_start,
          range_end:    range_end,
          number:       number,
          country_code: country_code,
          name:         name
        )

        expect(asn).to be_valid
      end
    end

    describe "range_start" do
      it "must require #range_start" do
        asn = described_class.new(
          version:      version,
          range_end:    range_end,
          number:       number,
          country_code: country_code,
          name:         name
        )

        expect(asn).to_not be_valid
        expect(asn.errors[:range_start]).to eq(
          ["can't be blank"]
        )
      end
    end

    describe "range_end" do
      it "must require #range_end" do
        asn = described_class.new(
          version:      version,
          range_start:  range_start,
          number:       number,
          country_code: country_code,
          name:         name
        )

        expect(asn).to_not be_valid
        expect(asn.errors[:range_end]).to eq(
          ["can't be blank"]
        )
      end
    end

    describe "number" do
      it "must require #number" do
        asn = described_class.new(
          version:      version,
          range_start:  range_start,
          range_end:    range_end,
          country_code: country_code,
          name:         name
        )

        expect(asn).to_not be_valid
        expect(asn.errors[:number]).to eq(
          ["can't be blank"]
        )
      end
    end

    describe "country_code" do
      it "must omit the name if unrouted" do
        asn = described_class.new(
          version:      version,
          range_start:  range_start,
          range_end:    range_end,
          number:       number
        )

        expect(asn).to be_valid
      end
    end

    describe "name" do
      it "must omit the name if unrouted" do
        asn = described_class.new(
          version:      version,
          range_start:  range_start,
          range_end:    range_end,
          number:       number
        )

        expect(asn).to be_valid
      end
    end
  end

  describe ".v4" do
    subject { described_class }

    before do
      subject.create(
        version:      6,
        range_start:  '64:ff9b::1:0:0',
        range_end:    '100::ffff:ffff:ffff:ffff',
        number:       0
      )

      subject.create(
        version:      4,
        range_start:  range_start,
        range_end:    range_end,
        number:       number,
        country_code: country_code,
        name:         name
      )

      subject.create(
        version:      6,
        range_start:  '::',
        range_end:    '::1',
        number:       0
      )
    end

    it "must query all IPv4 ASNs" do
      asns = subject.v4

      expect(asns).to_not be_empty
      expect(asns.map(&:version)).to all(eq(4))
    end

    after { described_class.destroy_all }
  end

  describe ".v6" do
    subject { described_class }

    before do
      subject.create(
        version:      4,
        range_start:  '1.0.0.0',
        range_end:    '1.0.0.255',
        number:       13335,
        country_code: 'US',
        name:         'CLOUDFLARENET'
      )

      subject.create(
        version:      6,
        range_start:  '64:ff9b::1:0:0',
        range_end:    '100::ffff:ffff:ffff:ffff',
        number:       0
      )

      subject.create(
        version:      4,
        range_start:  '1.0.1.0',
        range_end:    '1.0.3.255',
        number:       0
      )
    end

    it "must query all IPv6 ASNs" do
      asns = subject.v6

      expect(asns).to_not be_empty
      expect(asns.map(&:version)).to all(eq(6))
    end

    after { described_class.destroy_all }
  end

  describe ".with_number" do
    subject { described_class }

    let(:number) { 3356 }

    before do
      subject.create(
        version:      4,
        range_start:  '3.248.0.0',
        range_end:    '3.255.255.255',
        number:       16509,
        country_code: 'US',
        name:         'AMAZON-02'
      )

      subject.create(
        version:      4,
        range_start:  '4.0.0.0',
        range_end:    '4.7.168.255',
        number:       number,
        country_code: 'US',
        name:         'LEVEL3'
      )

      subject.create(
        version:      4,
        range_start:  '4.7.169.0',
        range_end:    '4.23.87.255',
        number:       number,
        country_code: 'US',
        name:         'LEVEL3'
      )

      subject.create(
        version:      4,
        range_start:  '4.23.88.0',
        range_end:    '4.23.89.255',
        number:       46164,
        country_code: 'US',
        name:         'ATT-MOBILITY-LABS'
      )
    end

    it "must query the ASN recrds with the matching number" do
      asns = subject.with_number(number)

      expect(asns.length).to eq(2)
      expect(asns).to all(be_kind_of(described_class))
      expect(asns[0].number).to eq(number)
      expect(asns[1].number).to eq(number)
    end

    after { described_class.destroy_all }
  end

  describe ".with_country_code" do
    subject { described_class }

    let(:country_code) { 'US' }

    before do
      subject.create(
        version:      4,
        range_start:  '3.30.0.0',
        range_end:    '3.32.255.255',
        number:       8987,
        country_code: 'IE',
        name:         'AMAZON EXPANSION'
      )

      subject.create(
        version:      4,
        range_start:  '4.0.0.0',
        range_end:    '4.7.168.255',
        number:       3356,
        country_code: country_code,
        name:         'LEVEL3'
      )

      subject.create(
        version:      4,
        range_start:  '4.7.169.0',
        range_end:    '4.23.87.255',
        number:       3356,
        country_code: country_code,
        name:         'LEVEL3'
      )

      subject.create(
        version:      4,
        range_start:  '5.0.0.0',
        range_end:    '5.0.255.255',
        number:       29256,
        country_code: 'SV',
        name:         'INT-PDN-STE-AS STE PDN Internal AS'
      )
    end

    it "must query the ASN recrds with the matching country code" do
      asns = subject.with_country_code(country_code)

      expect(asns.length).to eq(2)
      expect(asns).to all(be_kind_of(described_class))
      expect(asns[0].country_code).to eq(country_code)
      expect(asns[1].country_code).to eq(country_code)
    end

    after { described_class.destroy_all }
  end

  describe ".with_name" do
    subject { described_class }

    let(:number) { 3356     }
    let(:name)   { 'LEVEL3' }

    before do
      subject.create(
        version:      4,
        range_start:  '3.248.0.0',
        range_end:    '3.255.255.255',
        number:       16509,
        country_code: 'US',
        name:         'AMAZON-02'
      )

      subject.create(
        version:      4,
        range_start:  '4.0.0.0',
        range_end:    '4.7.168.255',
        number:       number,
        country_code: 'US',
        name:         name
      )

      subject.create(
        version:      4,
        range_start:  '4.7.169.0',
        range_end:    '4.23.87.255',
        number:       number,
        country_code: 'US',
        name:         name
      )

      subject.create(
        version:      4,
        range_start:  '4.23.88.0',
        range_end:    '4.23.89.255',
        number:       46164,
        country_code: 'US',
        name:         'ATT-MOBILITY-LABS'
      )
    end

    it "must query the ASN recrds with the matching number" do
      asns = subject.with_name(name)

      expect(asns.length).to eq(2)
      expect(asns).to all(be_kind_of(described_class))
      expect(asns[0].name).to eq(name)
      expect(asns[1].name).to eq(name)
    end

    after { described_class.destroy_all }
  end

  describe ".containing_ip" do
    subject { described_class }

    before do
      subject.create(
        version:      version,
        range_start:  range_start,
        range_end:    range_end,
        number:       number,
        country_code: country_code,
        name:         name
      )
    end

    let(:ip) { "4.4.4.4" }

    it "must find the #{described_class} that contains the given IP address" do
      asn = subject.containing_ip(ip)

      expect(asn).to be_kind_of(described_class)
      expect(asn.version).to eq(version)
      expect(asn.range_start).to eq(range_start)
      expect(asn.range_end).to eq(range_end)
      expect(asn.number).to eq(number)
      expect(asn.country_code).to eq(country_code)
      expect(asn.name).to eq(name)
    end

    after { described_class.destroy_all }
  end

  subject do
    described_class.new(
      version:      version,
      range_start:  range_start,
      range_end:    range_end,
      number:       number,
      country_code: country_code,
      name:         name
    )
  end

  describe "#range_start_ipaddr" do
    context "when #range_start is set" do
      it "must return an IPAddr of #range_start" do
        expect(subject.range_start_ipaddr).to be_kind_of(IPAddr)
        expect(subject.range_start_ipaddr.to_s).to eq(subject.range_start)
      end
    end

    context "when #range_start is nil" do
      subject { described_class.new }

      it "must return nil" do
        expect(subject.range_start_ipaddr).to be(nil)
      end
    end
  end

  describe "#range_end_ipaddr" do
    context "when #range_end is set" do
      it "must return an IPAddr of #range_end" do
        expect(subject.range_end_ipaddr).to be_kind_of(IPAddr)
        expect(subject.range_end_ipaddr.to_s).to eq(subject.range_end)
      end
    end

    context "when #range_end is nil" do
      subject { described_class.new }

      it "must return nil" do
        expect(subject.range_end_ipaddr).to be(nil)
      end
    end
  end

  describe "#ip_addresses" do
    let(:address1) { '4.1.1.1' }
    let(:address2) { '4.2.2.2' }
    let(:address3) { '4.3.3.3' }

    before do
      Ronin::DB::IPAddress.create(address: '3.255.255.255')
      Ronin::DB::IPAddress.create(address: address1)
      Ronin::DB::IPAddress.create(address: address2)
      Ronin::DB::IPAddress.create(address: address3)
      Ronin::DB::IPAddress.create(address: '4.7.169.0')
    end

    it "must query all IP addresses that are in between the first and last IP address" do
      ip_addresses = subject.ip_addresses

      expect(ip_addresses.length).to eq(3)
      expect(ip_addresses).to all(be_kind_of(Ronin::DB::IPAddress))
      expect(ip_addresses[0].address).to eq(address1)
      expect(ip_addresses[1].address).to eq(address2)
      expect(ip_addresses[2].address).to eq(address3)
    end

    after { Ronin::DB::IPAddress.destroy_all }
  end

  describe "#save" do
    subject do
      described_class.create(
        version:      4,
        range_start:  range_start,
        range_end:    range_end,
        number:       number,
        country_code: country_code,
        name:         name
      )
    end

    it "must set #range_start_hton" do
      expect(subject.range_start_hton).to eq(subject.range_start_ipaddr.hton)
    end

    it "must set #range_end_hton" do
      expect(subject.range_end_hton).to eq(subject.range_end_ipaddr.hton)
    end

    after { subject.destroy }
  end

  describe "#to_s" do
    it "must return the 'AS...' String" do
      expect(subject.to_s).to eq("AS#{number}")
    end
  end
end
