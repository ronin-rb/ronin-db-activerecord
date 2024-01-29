require 'spec_helper'
require 'ronin/db/web_vuln'
require 'ronin/db/url'

describe Ronin::DB::WebVuln do
  it "must use the 'ronin_web_vulns' table" do
    expect(described_class.table_name).to eq('ronin_web_vulns')
  end

  describe ".with_type" do
    subject { described_class }

    before do
      url = Ronin::DB::URL.import('https://example.com/page.php?id=1&foo=2&bar=3&baz=4')

      Ronin::DB::WebVuln.create(
        type:           :sqli,
        request_method: :get,
        query_param:    'id',
        url:            url
      )

      Ronin::DB::WebVuln.create(
        type:           :lfi,
        request_method: :get,
        query_param:    'foo',
        url:            url
      )

      Ronin::DB::WebVuln.create(
        type:           :sqli,
        request_method: :get,
        query_param:    'bar',
        url:            url
      )
    end

    it "must query all #{described_class}s with the matching #type" do
      web_vulns = subject.with_type(:sqli)

      expect(web_vulns.length).to eq(2)

      expect(web_vulns[0].type).to eq('sqli')
      expect(web_vulns[0].query_param).to eq('bar')

      expect(web_vulns[1].type).to eq('sqli')
      expect(web_vulns[1].query_param).to eq('id')
    end

    after do
      Ronin::DB::WebVuln.destroy_all
      Ronin::DB::URL.destroy_all
      Ronin::DB::URLQueryParamName.destroy_all
      Ronin::DB::URLScheme.destroy_all
      Ronin::DB::HostName.destroy_all
    end
  end

  describe ".with_query_param" do
    subject { described_class }

    let(:query_param) { 'foo' }

    before do
      url = Ronin::DB::URL.import('https://example.com/page.php?id=1&foo=2&bar=3&baz=4')

      Ronin::DB::WebVuln.create(
        type:           :sqli,
        request_method: :get,
        query_param:    'id',
        url:            url
      )

      Ronin::DB::WebVuln.create(
        type:           :lfi,
        request_method: :get,
        query_param:    query_param,
        url:            url
      )

      Ronin::DB::WebVuln.create(
        type:           :rfi,
        request_method: :get,
        query_param:    query_param,
        url:            url
      )
    end

    it "must query all #{described_class}s with the matching #query_param" do
      web_vulns = subject.with_query_param(query_param)

      expect(web_vulns.length).to eq(2)

      expect(web_vulns[0].type).to eq('lfi')
      expect(web_vulns[0].query_param).to eq(query_param)

      expect(web_vulns[1].type).to eq('rfi')
      expect(web_vulns[1].query_param).to eq(query_param)
    end

    after do
      Ronin::DB::WebVuln.destroy_all
      Ronin::DB::URL.destroy_all
      Ronin::DB::URLQueryParamName.destroy_all
      Ronin::DB::URLScheme.destroy_all
      Ronin::DB::HostName.destroy_all
    end
  end

  describe ".with_header_name" do
    subject { described_class }

    let(:header_name) { 'user' }

    before do
      url = Ronin::DB::URL.import('https://example.com/page.php?id=1&foo=2&bar=3&baz=4')

      Ronin::DB::WebVuln.create(
        type:           :sqli,
        request_method: :get,
        query_param:    'id',
        url:            url
      )

      Ronin::DB::WebVuln.create(
        type:           :lfi,
        request_method: :get,
        header_name:    header_name,
        url:            url
      )

      Ronin::DB::WebVuln.create(
        type:           :rfi,
        request_method: :get,
        header_name:    header_name,
        url:            url
      )
    end

    it "must query all #{described_class}s with the matching #header_name" do
      web_vulns = subject.with_header_name(header_name)

      expect(web_vulns.length).to eq(2)

      expect(web_vulns[0].type).to eq('lfi')
      expect(web_vulns[0].header_name).to eq(header_name)

      expect(web_vulns[1].type).to eq('rfi')
      expect(web_vulns[1].header_name).to eq(header_name)
    end

    after do
      Ronin::DB::WebVuln.destroy_all
      Ronin::DB::URL.destroy_all
      Ronin::DB::URLQueryParamName.destroy_all
      Ronin::DB::URLScheme.destroy_all
      Ronin::DB::HostName.destroy_all
    end
  end

  describe ".with_form_param" do
    subject { described_class }

    let(:form_param) { 'user' }

    before do
      url = Ronin::DB::URL.import('https://example.com/page.php?id=1&foo=2&bar=3&baz=4')

      Ronin::DB::WebVuln.create(
        type:           :sqli,
        request_method: :get,
        query_param:    'id',
        url:            url
      )

      Ronin::DB::WebVuln.create(
        type:           :lfi,
        request_method: :get,
        form_param:     form_param,
        url:            url
      )

      Ronin::DB::WebVuln.create(
        type:           :rfi,
        request_method: :get,
        form_param:     form_param,
        url:            url
      )
    end

    it "must query all #{described_class}s with the matching #form_param" do
      web_vulns = subject.with_form_param(form_param)

      expect(web_vulns.length).to eq(2)

      expect(web_vulns[0].type).to eq('lfi')
      expect(web_vulns[0].form_param).to eq(form_param)

      expect(web_vulns[1].type).to eq('rfi')
      expect(web_vulns[1].form_param).to eq(form_param)
    end

    after do
      Ronin::DB::WebVuln.destroy_all
      Ronin::DB::URL.destroy_all
      Ronin::DB::URLQueryParamName.destroy_all
      Ronin::DB::URLScheme.destroy_all
      Ronin::DB::HostName.destroy_all
    end
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
      let(:query_param) { "query_param" }

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
