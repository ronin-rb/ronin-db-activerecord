require 'spec_helper'
require 'ronin/db/http_header_name'

describe Ronin::DB::HTTPHeaderName do
  it "must use the 'ronin_http_header_names' table" do
    expect(described_class.table_name).to eq('ronin_http_header_names')
  end

  let(:name) { 'foo' }

  describe "validations" do
    describe "name" do
      it "must require name attribute" do
        http_header_name = described_class.new
        expect(http_header_name).to_not be_valid
        expect(http_header_name.errors[:name]).to eq(
          ["can't be blank"]
        )

        http_header_name = described_class.new(name: name)
        expect(http_header_name).to be_valid
      end
    end
  end
end
