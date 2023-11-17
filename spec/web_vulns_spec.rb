require 'spec_helper'
require 'ronin/db/web_vuln'
require 'ronin/db/url'

describe Ronin::DB::WebVuln do
  it "must use the 'ronin_web_vulns' table" do
    expect(described_class.table_name).to eq('ronin_web_vulns')
  end

  let(:url_scheme)    { Ronin::DB::URLScheme.find_or_initialize_by(name: 'https') }
  let(:url_host_name) { Ronin::DB::HostName.find_or_initialize_by(name: 'www.example.com') }
  let(:url_port)      { Ronin::DB::Port.find_or_initialize_by(protocol: :tcp, number: 8080) }
  let(:url)           { Ronin::DB::URL.new(scheme: url_scheme, host_name: url_host_name, port: url_port) }

  subject do
    described_class.new(
      url: url,
      query_param: query_param
    )
  end

  describe "#param_validations" do
    before do
      subject.param_validation
    end

    context "for WebVuln with at least on param present" do
      let(:query_param) { "string" }

      it "must pass the validation" do
        expect(subject.errors).to be_empty
      end
    end

    context "for WebVuln without present params" do
      let(:query_param) { nil }

      it "must add error" do
        expect(subject.errors.size).to be(1)
        expect(subject.errors[:base]).to eq(["query_param, header_name, cookie_param or from_param must be present"])
      end
    end
  end
end
