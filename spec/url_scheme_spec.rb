require 'spec_helper'
require 'ronin/db/url_scheme'

describe Ronin::DB::URLScheme do
  it "must use the 'ronin_url_schemes' table" do
    expect(described_class.table_name).to eq('ronin_url_schemes')
  end

  let(:name) { 'http' }

  describe "validations" do
    describe "name" do
      subject { described_class.new(name: 'http') }

      it "must require a name attribute" do
        url_scheme = described_class.new
        expect(url_scheme).to_not be_valid
        expect(url_scheme.errors[:name]).to eq(
          ["can't be blank"]
        )

        url_scheme = described_class.new(name: name)
        expect(url_scheme).to be_valid
      end

      it "msst require a unique name" do
        described_class.create(name: name)

        url_scheme = described_class.new(name: name)
        expect(url_scheme).to_not be_valid
        expect(url_scheme.errors[:name]).to eq(
          ["has already been taken"]
        )

        described_class.destroy_all
      end
    end
  end
end
