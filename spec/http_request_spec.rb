require 'spec_helper'
require 'ronin/db/http_request'

describe Ronin::DB::HTTPRequest do
  it "must use the 'ronin_http_requests' table" do
    expect(described_class.table_name).to eq('ronin_http_requests')
  end

  let(:name)  { 'foo' }
  let(:value) { 'bar' }

  let(:http_header_name) do
    Ronin::DB::HTTPHeaderName.find_or_initialize_by(name: name)
  end

  let(:version)        { '1.1' }
  let(:request_method) { :get }
  let(:path)           { '/search' }

  subject do
    described_class.new(
      version:        version,
      request_method: request_method,
      path:           path
    )
  end

  describe "validations" do
    describe "version" do
      %w[1.0 1.1 2.0].each do |valid_version|
        it "must accept '#{valid_version}'" do
          request = described_class.new(
                      version:        valid_version,
                      request_method: request_method,
                      path:           path
                    )

          expect(request).to be_valid
        end
      end

      it "must not accept any other version String" do
        request = described_class.new(
                    version:        '3.0',
                    request_method: request_method,
                    path:           path
                  )

        expect(request).to_not be_valid
        expect(request.errors[:version]).to eq(
          ["is not included in the list"]
        )
      end

      it "must not accept any other String" do
        request = described_class.new(
                    version:        'foo',
                    request_method: request_method,
                    path:           path
                  )

        expect(request).to_not be_valid
        expect(request.errors[:version]).to eq(
          ["is not included in the list"]
        )
      end

      it "must not accept nil" do
        request = described_class.new(
                    version:        nil,
                    request_method: request_method,
                    path:           path
                  )

        expect(request).to_not be_valid
        expect(request.errors[:version]).to eq(
          ["can't be blank", "is not included in the list"]
        )
      end

      describe "source_ip" do
        let(:address)      { '127.0.0.1' }
        let(:ipv4_address) { '93.184.216.34' }
        let(:ipv6_address) { '2606:2800:220:1:248:1893:25c8:1946' }

        it "must not require an address" do
          ip_address = described_class.new
          expect(ip_address).to_not be_valid

          ip_address = described_class.new(
            version:        version,
            request_method: request_method,
            path:           path
          )
          expect(ip_address).to be_valid
        end

        it "must accept IPv4 addresses" do
          ip_address = described_class.new(
            version:        version,
            request_method: request_method,
            path:           path,
            source_ip:      ipv4_address
          )
          expect(ip_address).to be_valid
        end

        it "must accept IPv6 addresses" do
          ip_address = described_class.new(
            version:        version,
            request_method: request_method,
            path:           path,
            source_ip:      ipv6_address
          )
          expect(ip_address).to be_valid
        end

        it "must not accept non-IP addresses" do
          ip_address = described_class.new(
            version:        version,
            request_method: request_method,
            path:           path,
            source_ip:      '0'
          )
          expect(ip_address).to_not be_valid
          expect(ip_address.errors[:source_ip]).to eq(
            ["Must be a valid IP address"]
          )
        end
      end
    end

    describe "request_method" do
      [
        :copy,
        :delete,
        :get,
        :head,
        :lock,
        :mkcol,
        :move,
        :options,
        :patch,
        :post,
        :propfind,
        :proppatch,
        :put,
        :trace,
        :unlock
      ].each do |valid_request_method|
        it "must accept #{valid_request_method.inspect}" do
          request = described_class.new(
                      version:        version,
                      request_method: valid_request_method,
                      path:           path
                    )

          expect(request).to be_valid
        end
      end

      it "must not accept any other Symbol" do
        expect {
          described_class.new(
            version:        version,
            request_method: :foo,
            path:           path
          )
        }.to raise_error(ArgumentError,"'foo' is not a valid request_method")
      end

      it "must not accept a nil value" do
        request = described_class.new(
                    version:        version,
                    request_method: nil,
                    path:           path
                  )

        expect(request).to_not be_valid
      end

      it "must require a request_method value" do
        request = described_class.new(
                    version: version,
                    path:    path
                  )

        expect(request).to_not be_valid
      end
    end

    describe "path" do
      it "must require a path" do
        request = described_class.new(
                    version:        version,
                    request_method: request_method
                  )

        expect(request).to_not be_valid
        expect(request.errors[:path]).to eq(
          ["can't be blank"]
        )
      end

      it "must require a non-empty path" do
        request = described_class.new(
                    version:        version,
                    request_method: request_method,
                    path:           ''
                  )

        expect(request).to_not be_valid
        expect(request.errors[:path]).to eq(
          ["can't be blank"]
        )
      end
    end
  end
end
