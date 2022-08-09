require 'spec_helper'
require 'ronin/db/http_response'

describe Ronin::DB::HTTPResponse do
  it "must use the 'ronin_http_responses' table" do
    expect(described_class.table_name).to eq('ronin_http_responses')
  end

  let(:name)  { 'foo' }
  let(:value) { 'bar' }

  let(:http_header_name) do
    Ronin::DB::HTTPHeaderName.find_or_initialize_by(name: name)
  end

  let(:version)        { '1.1' }
  let(:request_method) { :get }
  let(:path)           { '/search' }

  let(:request) do
    Ronin::DB::HTTPRequest.new(
      version:        version,
      request_method: request_method,
      path:           path
    )
  end

  let(:status) { 200 }
  subject do
    described_class.new(
      status:  status,
      request: request
    )
  end

  describe "validations" do
    describe "status" do
      it "must require a status" do
        response = described_class.new(request: request)

        expect(response).to_not be_valid
        expect(response.errors[:status]).to eq(
          ["can't be blank", "is not included in the list"]
        )
      end

      it "must not allow nil" do
        response = described_class.new(
                     status:  nil,
                     request: request
                   )

        expect(response).to_not be_valid
        expect(response.errors[:status]).to eq(
          ["can't be blank", "is not included in the list"]
        )
      end

      [
        100, 101, 103,
        200, 201, 202, 203, 204, 206, 207, 208, 226,
        300, 301, 302, 303, 304, 305, 306, 307, 308,
        400, 401, 402, 403, 404, 405, 406, 407, 408, 409,
        410, 411, 412, 413, 414, 415, 416, 417, 418,
        421, 422, 423, 424, 425, 426, 428, 429,
        431, 451,
        500, 501, 502, 503, 504, 505, 506, 507, 508, 511
      ].each do |valid_status|
        it "must accept #{valid_status}" do
          response = described_class.new(
                       status:  valid_status,
                       request: request
                     )

          expect(response).to be_valid
        end
      end

      it "must not accept any other Integer" do
        response = described_class.new(
                     status:  600,
                     request: request
                   )

        expect(response).to_not be_valid
        expect(response.errors[:status]).to eq(
          ["is not included in the list"]
        )
      end
    end

    describe "request" do
      it "must require a parent request" do
        response = described_class.new(status: status)

        expect(response).to_not be_valid
        expect(response.errors[:request]).to eq(
          ["must exist"]
        )
      end
    end
  end
end
