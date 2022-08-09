require 'spec_helper'
require 'ronin/db/http_response_header'
require 'ronin/db/http_response'

describe Ronin::DB::HTTPResponseHeader do
  it "must use the 'ronin_http_response_headers' table" do
    expect(described_class.table_name).to eq('ronin_http_response_headers')
  end

  let(:name)  { 'foo' }
  let(:value) { 'bar' }

  let(:http_header_name) do
    Ronin::DB::HTTPHeaderName.find_or_initialize_by(name: name)
  end

  let(:request_method) { :get }
  let(:path)           { '/search' }
  let(:request) do
    Ronin::DB::HTTPRequest.new(
      request_method: request_method,
      path:           path,
      respnse:        response
    )
  end
  let(:response) { Ronin::DB::HTTPResponse.new }

  describe "validations" do
    describe "name" do
      it "must require a name association" do
        http_response_header = described_class.new(value: value)
        expect(http_response_header).to_not be_valid
        expect(http_response_header.errors[:name]).to eq(
          ["must exist"]
        )

        http_response_header = described_class.new(
          name:     http_header_name,
          value:    value,
          response: response
        )
        expect(http_response_header).to be_valid
      end
    end

    describe "response" do
      it "must require a response association" do
        http_response_header = described_class.new(
          name:  http_header_name,
          value: value
        )

        expect(http_response_header).to_not be_valid
        expect(http_response_header.errors[:response]).to eq(
          ['must exist']
        )
      end
    end
  end

  subject do
    described_class.new(
      name:     Ronin::DB::HTTPHeaderName.new(name: name),
      value:    value,
      response: response
    )
  end

  describe "#to_s" do
    it "should dump a name and a value into a String" do
      expect(subject.to_s).to eq("#{name}: #{value}")
    end
  end
end
