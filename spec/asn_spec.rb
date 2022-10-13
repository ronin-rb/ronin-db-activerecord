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

  describe "#range_startaddr" do
    context "when #range_start is set" do
      it "must return an IPAddr of #range_start" do
        expect(subject.range_startaddr).to be_kind_of(IPAddr)
        expect(subject.range_startaddr.to_s).to eq(subject.range_start)
      end
    end

    context "when #range_start is nil" do
      subject { described_class.new }

      it "must return nil" do
        expect(subject.range_startaddr).to be(nil)
      end
    end
  end

  describe "#range_endaddr" do
    context "when #range_end is set" do
      it "must return an IPAddr of #range_end" do
        expect(subject.range_endaddr).to be_kind_of(IPAddr)
        expect(subject.range_endaddr.to_s).to eq(subject.range_end)
      end
    end

    context "when #range_end is nil" do
      subject { described_class.new }

      it "must return nil" do
        expect(subject.range_endaddr).to be(nil)
      end
    end
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
      expect(subject.range_start_hton).to eq(subject.range_startaddr.hton)
    end

    it "must set #range_end_hton" do
      expect(subject.range_end_hton).to eq(subject.range_endaddr.hton)
    end

    after { subject.destroy }
  end
end
