require 'spec_helper'
require 'ronin/db/software'

describe Ronin::DB::Software do
  it "must use the 'ronin_softwares' table" do
    expect(described_class.table_name).to eq('ronin_softwares')
  end

  let(:name)    { 'Test'  }
  let(:version) { '0.1.0' }
  let(:vendor)  { 'TestCo' }

  describe "validations" do
    describe "nmae" do
      it "must require name attribute" do
        software = described_class.new(version: version)
        expect(software).to_not be_valid
        expect(software.errors[:name]).to eq(
          ["can't be blank"]
        )

        software = described_class.new(name: name, version: version)
        expect(software).to be_valid
      end
    end

    describe "version" do
      it "should require version attribute" do
        software = described_class.new(name: name)
        expect(software).to_not be_valid
        expect(software.errors[:version]).to eq(
          ["can't be blank"]
        )

        software = described_class.new(name: name, version: version)
        expect(software).to be_valid
      end
    end

    it "the name and version attributes must be unique" do
      described_class.create(name: name, version: version)

      software = described_class.new(name: name, version: version)
      expect(software).to_not be_valid
      expect(software.errors[:version]).to eq(
        ['has already been taken']
      )

      described_class.delete_all
    end
  end

  subject do
    described_class.new(
      name:    name,
      version: version,
      vendor:  Ronin::DB::SoftwareVendor.new(name: vendor)
    )
  end

  describe "#to_s" do
    it "should be convertable to a String" do
      expect(subject.to_s).to eq("#{vendor} #{name} #{version}")
    end

    context "without a vendor" do
      subject do
        described_class.new(name: name, version: version)
      end

      it "should ignore the missing vendor information" do
        expect(subject.to_s).to eq("#{name} #{version}")
      end
    end
  end
end
