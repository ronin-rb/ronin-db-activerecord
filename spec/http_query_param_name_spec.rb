require 'spec_helper'
require 'ronin/db/http_query_param_name'

describe Ronin::DB::HTTPQueryParamName do
  it "must use the 'ronin_http_query_param_names' table" do
    expect(described_class.table_name).to eq('ronin_http_query_param_names')
  end

  let(:name) { 'foo' }

  describe "validations" do
    describe "name" do
      it "should require name attribute" do
        http_query_param_name = described_class.new
        expect(http_query_param_name).to_not be_valid
        expect(http_query_param_name.errors[:name]).to eq(
          ["can't be blank"]
        )

        http_query_param_name = described_class.new(name: name)
        expect(http_query_param_name).to be_valid
      end
    end
  end
end
