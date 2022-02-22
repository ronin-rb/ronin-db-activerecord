require 'spec_helper'
require 'ronin/db/url_query_param_name'

describe Ronin::DB::URLQueryParamName do
  it "must use the 'ronin_url_query_param_names' table" do
    expect(described_class.table_name).to eq('ronin_url_query_param_names')
  end

  let(:name) { 'foo' }

  describe "validations" do
    describe "name" do
      it "should require name attribute" do
        url_query_param_name = described_class.new
        expect(url_query_param_name).to_not be_valid
        expect(url_query_param_name.errors[:name]).to eq(
          ["can't be blank"]
        )

        url_query_param_name = described_class.new(name: name)
        expect(url_query_param_name).to be_valid
      end
    end
  end
end
