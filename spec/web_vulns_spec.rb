require 'spec_helper'
require 'ronin/db/web_vuln'
require 'ronin/db/url'

describe Ronin::DB::WebVuln do
  it "must use the 'ronin_web_vulns' table" do
    expect(described_class.table_name).to eq('ronin_web_vulns')
  end

  describe ".for_host" do
    subject { described_class }

    let(:host_name) { 'two.example.com' }

    before do
      url1 = Ronin::DB::URL.import("https://one.example.com/page1.php?id=1")
      url2 = Ronin::DB::URL.import("https://#{host_name}/page2.php?id=1")
      url3 = Ronin::DB::URL.import("https://#{host_name}/page3.php?id=1")

      Ronin::DB::WebVuln.create(
        type:           :sqli,
        request_method: :get,
        query_param:    'id',
        url:            url1
      )

      Ronin::DB::WebVuln.create(
        type:           :sqli,
        request_method: :get,
        query_param:    'id',
        url:            url2
      )

      Ronin::DB::WebVuln.create(
        type:           :sqli,
        request_method: :get,
        query_param:    'id',
        url:            url3
      )
    end

    it "must query all #{described_class}s with the matching URL's host name" do
      web_vulns = subject.for_host(host_name)

      expect(web_vulns.length).to eq(2)

      expect(web_vulns[0].type).to eq('sqli')
      expect(web_vulns[0].url.host_name.name).to eq(host_name)
      expect(web_vulns[0].url.path).to eq('/page2.php')

      expect(web_vulns[1].type).to eq('sqli')
      expect(web_vulns[1].url.host_name.name).to eq(host_name)
      expect(web_vulns[1].url.path).to eq('/page3.php')
    end

    after do
      Ronin::DB::WebVuln.destroy_all
      Ronin::DB::URL.destroy_all
      Ronin::DB::URLQueryParamName.destroy_all
      Ronin::DB::URLScheme.destroy_all
      Ronin::DB::HostName.destroy_all
    end
  end

  describe ".for_domain" do
    subject { described_class }

    let(:domain) { 'example.com' }

    before do
      url1 = Ronin::DB::URL.import("https://other.com/page1.php?id=1")
      url2 = Ronin::DB::URL.import("https://one.#{domain}/page2.php?id=1")
      url3 = Ronin::DB::URL.import("https://two.#{domain}/page3.php?id=1")

      Ronin::DB::WebVuln.create(
        type:           :sqli,
        request_method: :get,
        query_param:    'id',
        url:            url1
      )

      Ronin::DB::WebVuln.create(
        type:           :sqli,
        request_method: :get,
        query_param:    'id',
        url:            url2
      )

      Ronin::DB::WebVuln.create(
        type:           :sqli,
        request_method: :get,
        query_param:    'id',
        url:            url3
      )
    end

    it "must query all #{described_class}s for all URL's with the matching domain" do
      web_vulns = subject.for_domain(domain)

      expect(web_vulns.length).to eq(2)

      expect(web_vulns[0].type).to eq('sqli')
      expect(web_vulns[0].url.host_name.name).to eq("one.#{domain}")
      expect(web_vulns[0].url.path).to eq('/page2.php')

      expect(web_vulns[1].type).to eq('sqli')
      expect(web_vulns[1].url.host_name.name).to eq("two.#{domain}")
      expect(web_vulns[1].url.path).to eq('/page3.php')
    end

    after do
      Ronin::DB::WebVuln.destroy_all
      Ronin::DB::URL.destroy_all
      Ronin::DB::URLQueryParamName.destroy_all
      Ronin::DB::URLScheme.destroy_all
      Ronin::DB::HostName.destroy_all
    end
  end

  describe ".for_path" do
    subject { described_class }

    let(:path) { '/path/to/page.php' }

    before do
      url1 = Ronin::DB::URL.import("https://other.com/page.php?id=1")
      url2 = Ronin::DB::URL.import("https://example.com#{path}?id=1")
      url3 = Ronin::DB::URL.import("https://example.com#{path}?id=2")

      Ronin::DB::WebVuln.create(
        type:           :sqli,
        request_method: :get,
        query_param:    'id',
        url:            url1
      )

      Ronin::DB::WebVuln.create(
        type:           :sqli,
        request_method: :get,
        query_param:    'id',
        url:            url2
      )

      Ronin::DB::WebVuln.create(
        type:           :ssti,
        request_method: :get,
        query_param:    'id',
        url:            url3
      )
    end

    it "must query all #{described_class}s for all URL's with the matching #path" do
      web_vulns = subject.for_path(path)

      expect(web_vulns.length).to eq(2)

      expect(web_vulns[0].type).to eq('sqli')
      expect(web_vulns[0].url.host_name.name).to eq('example.com')
      expect(web_vulns[0].url.path).to eq(path)

      expect(web_vulns[1].type).to eq('ssti')
      expect(web_vulns[1].url.host_name.name).to eq('example.com')
      expect(web_vulns[1].url.path).to eq(path)
    end

    after do
      Ronin::DB::WebVuln.destroy_all
      Ronin::DB::URL.destroy_all
      Ronin::DB::URLQueryParamName.destroy_all
      Ronin::DB::URLScheme.destroy_all
      Ronin::DB::HostName.destroy_all
    end
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

  describe ".with_cookie_param" do
    subject { described_class }

    let(:cookie_param) { 'user' }

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
        cookie_param:    cookie_param,
        url:            url
      )

      Ronin::DB::WebVuln.create(
        type:           :rfi,
        request_method: :get,
        cookie_param:    cookie_param,
        url:            url
      )
    end

    it "must query all #{described_class}s with the matching #cookie_param" do
      web_vulns = subject.with_cookie_param(cookie_param)

      expect(web_vulns.length).to eq(2)

      expect(web_vulns[0].type).to eq('lfi')
      expect(web_vulns[0].cookie_param).to eq(cookie_param)

      expect(web_vulns[1].type).to eq('rfi')
      expect(web_vulns[1].cookie_param).to eq(cookie_param)
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

  describe ".with_request_method" do
    subject { described_class }

    let(:request_method) { 'post' }

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
        form_param:     'user',
        request_method: request_method,
        url:            url
      )

      Ronin::DB::WebVuln.create(
        type:           :open_redirect,
        header_name:    'X-Foo',
        request_method: request_method,
        url:            url
      )
    end

    it "must query all #{described_class}s with the matching #request_method" do
      web_vulns = subject.with_request_method(request_method)

      expect(web_vulns.length).to eq(2)

      expect(web_vulns[0].type).to eq('lfi')
      expect(web_vulns[0].form_param).to eq('user')
      expect(web_vulns[0].request_method).to eq(request_method)

      expect(web_vulns[1].type).to eq('open_redirect')
      expect(web_vulns[1].header_name).to eq('X-Foo')
      expect(web_vulns[1].request_method).to eq(request_method)
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
