require 'spec_helper'
require 'ronin/db/software_vendor'

describe Ronin::DB::SoftwareVendor do
  it "must use the 'ronin_software_vendors' table" do
    expect(described_class.table_name).to eq('ronin_software_vendors')
  end

  let(:name) { 'TestCo' }

  describe "validations" do
    describe "name" do
      it "must require name attribute" do
        software_vendor = described_class.new
        expect(software_vendor).to_not be_valid
        expect(software_vendor.errors[:name]).to eq(
          ["can't be blank"]
        )

        software_vendor = described_class.new(name: name)
        expect(software_vendor).to be_valid
      end
    end
  end

  subject { described_class.new(name: name) }

  describe "#to_s" do
    it "must include the vendor name" do
      expect(subject.to_s).to eq(name)
    end
  end
end
