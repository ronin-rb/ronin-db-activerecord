require 'spec_helper'
require 'ronin/db/advisory'

describe Ronin::DB::Advisory do
  describe described_class::ID do
    describe ".parse" do
      subject { described_class }

      context "when given a CVE ID" do
        let(:year)       { 2020   }
        let(:identifier) { '1234' }
        let(:id)         { "CVE-#{year}-#{identifier}" }

        it "must return a Hash containing the ID, 'CVE' prefix, the year, and the identifier" do
          expect(subject.parse(id)).to eq(
            {
              id:         id,
              prefix:     'CVE',
              year:       year,
              identifier: identifier
            }
          )
        end
      end

      context "when given a MS ID" do
        let(:year)       { 2017  }
        let(:identifier) { '010' }
        let(:id)         { "MS#{year - 2000}-#{identifier}" }

        it "must return a Hash containing the ID, 'MS' prefix, the full year, and the identifier" do
          expect(subject.parse(id)).to eq(
            {
              id:         id,
              prefix:     'MS',
              year:       year,
              identifier: identifier
            }
          )
        end
      end

      context "when given a RHSA ID" do
        let(:year)       { 2022   }
        let(:identifier) { '6187' }
        let(:id)         { "RHSA-#{year}:#{identifier}" }

        it "must return a Hash containing the ID, 'RHSA' prefix, the year, and the identifier" do
          expect(subject.parse(id)).to eq(
            {
              id:         id,
              prefix:     'RHSA',
              year:       year,
              identifier: identifier
            }
          )
        end
      end

      context "when given a GHSA ID" do
        let(:identifier) { '3hhc-qp5v-9p2j'     }
        let(:id)         { "GHSA-#{identifier}" }

        it "must return a Hash containing the ID and the identifier" do
          expect(subject.parse(id)).to eq(
            {
              id:         id,
              prefix:     'GHSA',
              identifier: identifier
            }
          )
        end
      end
    end
  end

  describe "validations" do
    describe "prefix" do
      subject do
      end

      it "must require a preifx" do
        advisory = described_class.new(
          id:         'CVE-2022-1234',
          year:       2022,
          identifier: '2022-1234'
        )
        expect(advisory).to_not be_valid
        expect(advisory.errors[:prefix]).to eq(["can't be blank"])

        advisory = described_class.new(
          id:         'CVE-2022-1234',
          prefix:     'CVE',
          year:       2022,
          identifier: '2022-1234'
        )
        expect(advisory).to be_valid
      end
    end

    describe "year" do
      it "must accept a nil value" do
        advisory = described_class.new(
          id:         'GHSA-3hhc-qp5v-9p2j',
          prefix:     'GHSA',
          year:       nil,
          identifier: '3hhc-qp5v-9p2j',
        )

        advisory.valid?
        p advisory.errors
        expect(advisory).to be_valid
      end

      it "must accept a numberic value" do
        advisory = described_class.new(
          id:         'CVE-2022-1234',
          prefix:     'CVE',
          year:       2022,
          identifier: '2022-1234'
        )

        expect(advisory).to be_valid
      end
    end

    describe "identifier" do
      it "must require a preifx" do
        advisory = described_class.new(
          id:         'CVE-2022-1234',
          prefix:     'CVE',
          year:       2022
        )
        expect(advisory).to_not be_valid
        expect(advisory.errors[:identifier]).to eq(["can't be blank"])

        advisory = described_class.new(
          id:         'CVE-2022-1234',
          prefix:     'CVE',
          year:       2022,
          identifier: '2022-1234'
        )
        expect(advisory).to be_valid
      end
    end
  end

  let(:prefix)     { 'CVE'  }
  let(:year)       { 2022   }
  let(:identifier) { '1234' }
  let(:id)         { "#{prefix}-#{year}-#{identifier}" }

  describe ".lookup" do
    let(:id) { 'CVE-2022-1234' }

    before do
      described_class.create(
        id:         'CVE-2000-1234',
        prefix:     'CVE',
        year:       2000,
        identifier: '2000-1234'
      )
      described_class.create(
        id:         id,
        prefix:     prefix,
        year:       year,
        identifier: identifier
      )
      described_class.create(
        id:         'CVE-2000-5678',
        prefix:     'CVE',
        year:       2000,
        identifier: '2000-5678'
      )
    end

    it "must query the #{described_class} with the matching ID" do
      advisory = described_class.lookup(id)

      expect(advisory).to be_kind_of(described_class)
      expect(advisory.id).to eq(id)
    end

    after { described_class.destroy_all }
  end

  describe ".import" do
    let(:id)        { 'CVE-2022-1234' }
    let(:parsed_id) { described_class::ID.parse(id) }

    subject { described_class.import(id) }

    it "must parse and import the advisory ID and return a new #{described_class}" do
      expect(subject.id).to eq(id)
      expect(subject.prefix).to     eq(parsed_id[:prefix])
      expect(subject.year).to       eq(parsed_id[:year])
      expect(subject.identifier).to eq(parsed_id[:identifier])
    end

    after { described_class.destroy_all }
  end

  subject do
    described_class.new(
      id:         id,
      prefix:     prefix,
      year:       year,
      identifier: identifier
    )
  end

  describe "#url" do
    context "when #prefix is 'CVE'" do
      let(:prefix)     { 'CVE'  }
      let(:year)       { 2022   }
      let(:identifier) { '1234' }
      let(:id)         { "#{prefix}-#{year}-#{identifier}" }

      subject do
        described_class.new(
          id:         id,
          prefix:     prefix,
          year:       year,
          identifier: identifier
        )
      end

      it "must return 'https://nvd.nist.gov/vuln/detail/CVE-YYYY-NNNN'" do
        expect(subject.url).to eq("https://nvd.nist.gov/vuln/detail/#{id}")
      end
    end

    context "when #prefix is 'RHSA'" do
      let(:prefix)     { 'RHSA' }
      let(:year)       { 2022   }
      let(:identifier) { '6187' }
      let(:id)         { "#{prefix}-#{year}:#{identifier}" }

      subject do
        described_class.new(
          id:         id,
          prefix:     prefix,
          year:       year,
          identifier: identifier
        )
      end

      it "must return 'https://access.redhat.com/errata/RHSA-YYYY-NNNN'" do
        expect(subject.url).to eq("https://access.redhat.com/errata/#{id}")
      end
    end

    context "when #prefix is 'GHSA'" do
      let(:prefix)     { 'GHSA' }
      let(:identifier) { '3hhc-qp5v-9p2j'     }
      let(:id)         { "#{prefix}-#{identifier}" }

      subject do
        described_class.new(
          id:         id,
          prefix:     prefix,
          identifier: identifier
        )
      end

      it "must return 'https://github.com/advisories/GHSA-...'" do
        expect(subject.url).to eq("https://github.com/advisories/#{id}")
      end
    end
  end

  describe "#to_s" do
    it "must return the #id" do
      expect(subject.to_s).to eq(id)
    end
  end
end
