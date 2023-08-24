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

      described_class.destroy_all
    end
  end

  describe ".with_version" do
    let(:version) { '1.2.3' }

    before do
      described_class.create(name: 'Minesweeper', version: '0.1')
      described_class.create(name: 'Solitare',    version: version)
      described_class.create(name: 'Notepad',     version: version)
    end

    subject { described_class }

    it "must find all #{described_class} with the matching version" do
      software = subject.with_version(version)

      expect(software.length).to eq(2)
      expect(software.map(&:version).uniq).to eq([version])
    end

    after do
      described_class.destroy_all
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
