require 'spec_helper'
require 'ronin/db/http_query_param'
require 'ronin/db/http_request'

describe Ronin::DB::HTTPQueryParam do
  it "must use the 'ronin_http_query_params' table" do
    expect(described_class.table_name).to eq('ronin_http_query_params')
  end

  let(:name)  { 'foo' }
  let(:value) { 'bar' }

  let(:http_query_param_name) do
    Ronin::DB::HTTPQueryParamName.find_or_initialize_by(name: name)
  end

  let(:request_method) { :get }
  let(:path)           { '/search' }
  let(:request) do
    Ronin::DB::HTTPRequest.new(
      request_method: request_method,
      path:           path
    )
  end

  describe "validations" do
    describe "name" do
      it "must require a name association" do
        http_query_param = described_class.new(value: value)
        expect(http_query_param).to_not be_valid
        expect(http_query_param.errors[:name]).to eq(
          ["must exist"]
        )

        http_query_param = described_class.new(
          name:    http_query_param_name,
          value:   value,
          request: request
        )
        expect(http_query_param).to be_valid
      end
    end

    describe "request" do
      it "must require a request association" do
        http_query_param = described_class.new(
          name:    http_query_param_name,
          value:   value
        )

        expect(http_query_param).to_not be_valid
        expect(http_query_param.errors[:request]).to eq(
          ['must exist']
        )
      end
    end
  end

  subject do
    described_class.new(
      name:    Ronin::DB::HTTPQueryParamName.new(name: name),
      value:   value,
      request: request
    )
  end

  describe "#to_s" do
    it "should dump a name and a value into a String" do
      expect(subject.to_s).to eq("#{name}=#{value}")
    end

    context "when an empty value" do
      let(:value) { '' }

      it "should ignore empty or nil values" do
        expect(subject.to_s).to eq("#{name}=")
      end
    end

    context "when a nil value" do
      let(:value) { nil }

      it "should ignore empty or nil values" do
        expect(subject.to_s).to eq("#{name}=")
      end
    end

    context "with special characters" do
      let(:value)         { 'bar baz' }
      let(:encoded_value) { URI::DEFAULT_PARSER.escape(value) }

      subject do
        described_class.new(
          name:  Ronin::DB::HTTPQueryParamName.new(name: name),
          value: value
        )
      end

      it "should escape special characters" do
        expect(subject.to_s).to eq("#{name}=#{encoded_value}")
      end
    end
  end
end
