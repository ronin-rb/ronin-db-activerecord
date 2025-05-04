require 'spec_helper'
require 'ronin/db/http_request_header'
require 'ronin/db/http_request'

describe Ronin::DB::HTTPRequestHeader do
  it "must use the 'ronin_http_request_headers' table" do
    expect(described_class.table_name).to eq('ronin_http_request_headers')
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
      path:           path
    )
  end

  describe "validations" do
    describe "name" do
      it "must require a name association" do
        http_request_header = described_class.new(value: value)
        expect(http_request_header).to_not be_valid
        expect(http_request_header.errors[:name]).to eq(
          ["must exist"]
        )

        http_request_header = described_class.new(
          name:    http_header_name,
          value:   value,
          request: request
        )
        expect(http_request_header).to be_valid
      end
    end

    describe "request" do
      it "must require a request association" do
        http_request_header = described_class.new(
          name:  http_header_name,
          value: value
        )

        expect(http_request_header).to_not be_valid
        expect(http_request_header.errors[:request]).to eq(
          ['must exist']
        )
      end
    end
  end

  subject do
    described_class.new(
      name:    Ronin::DB::HTTPHeaderName.new(name: name),
      value:   value,
      request: request
    )
  end

  describe "#to_s" do
    it "must dump a name and a value into a String" do
      expect(subject.to_s).to eq("#{name}: #{value}")
    end
  end
end
