require 'spec_helper'
require 'ronin/db/service'

describe Ronin::DB::Service do
  it "must use the 'ronin_services' table" do
    expect(described_class.table_name).to eq('ronin_services')
  end

  let(:name) { 'Apache' }

  describe "validations" do
    describe "name" do
      it "must require a name" do
        service = described_class.new
        expect(service).to_not be_valid
        expect(service.errors[:name]).to eq(
          ["can't be blank"]
        )

        service = described_class.new(name: name)
        expect(service).to be_valid
      end

      it "must require a unique name" do
        described_class.create(name: name)

        service = described_class.new(name: name)
        expect(service).not_to be_valid
        expect(service.errors[:name]).to eq(
          ["has already been taken"]
        )

        described_class.destroy_all
      end
    end
  end

  subject { described_class.new(name: name) }
end
