require 'spec_helper'
require 'ronin/db/web_vuln'
require 'ronin/db/url'

describe Ronin::DB::WebVuln do
  it "must use the 'ronin_web_vulns' table" do
    expect(described_class.table_name).to eq('ronin_web_vulns')
  end

  let(:type)           { :lfi }
  let(:request_method) { :get }
  let(:url_scheme) do
    Ronin::DB::URLScheme.find_or_initialize_by(name: 'https')
  end
  let(:url_host_name) do
    Ronin::DB::HostName.find_or_initialize_by(name: 'www.example.com')
  end
  let(:url_port) do
    Ronin::DB::Port.find_or_initialize_by(protocol: :tcp, number: 8080)
  end
  let(:url) do
    Ronin::DB::URL.new(
      scheme:    url_scheme,
      host_name: url_host_name,
      port:      url_port
    )
  end
  let(:query_param) { 'id' }

  subject do
    described_class.new(
      type:           type,
      request_method: request_method,
      url:            url,
      query_param:    query_param
    )
  end

  describe "validations" do
    describe "type" do
      it "must require a type" do
        web_vuln = described_class.new(
          request_method: request_method,
          url:            url,
          query_param:    query_param
        )

        expect(web_vuln).to_not be_valid
        expect(web_vuln.errors[:type]).to eq(["can't be blank"])
      end

      [
        :lfi,
        :rfi,
        :sqli,
        :ssti,
        :open_redirect,
        :reflected_xss,
        :command_injection
      ].each do |valid_type|
        it "must accept #{valid_type.inspect}" do
          web_vuln = described_class.new(
            type:           valid_type,
            request_method: request_method,
            url:            url,
            query_param:    query_param
          )

          expect(web_vuln).to be_valid
        end
      end

      it "must not accept other values" do
        expect {
          described_class.new(
            type:           :other,
            request_method: request_method,
            url:            url,
            query_param:    query_param
          )
        }.to raise_error(ArgumentError,"'other' is not a valid type")
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
          web_vuln = described_class.new(
            type:           type,
            request_method: valid_request_method,
            url:            url,
            query_param:    query_param
          )

          expect(web_vuln).to be_valid
        end
      end

      it "must not accept other values" do
        expect {
          described_class.new(
            type:           type,
            request_method: :other,
            url:            url,
            query_param:    query_param
          )
        }.to raise_error(ArgumentError,"'other' is not a valid request_method")
      end
    end

    describe "lfi_os" do
      [
        nil,
        'unix',
        'windows'
      ].each do |valid_lfi_os|
        it "must accept #{valid_lfi_os.inspect}" do
          web_vuln = described_class.new(
            type:           :lfi,
            lfi_os:         valid_lfi_os,
            request_method: request_method,
            url:            url,
            query_param:    query_param
          )

          expect(web_vuln).to be_valid
        end
      end

      it "must not accept other values" do
        expect {
          described_class.new(
            type:           :lfi,
            lfi_os:         :other,
            request_method: request_method,
            url:            url,
            query_param:    query_param
          )
        }.to raise_error(ArgumentError,"'other' is not a valid lfi_os")
      end
    end

    describe "lfi_filter_bypass" do
      [
        nil,
        'null_byte',
        'base64',
        'rot13',
        'zlib'
      ].each do |valid_lfi_filter_bypass|
        it "must accept #{valid_lfi_filter_bypass.inspect}" do
          web_vuln = described_class.new(
            type:              :lfi,
            lfi_filter_bypass: valid_lfi_filter_bypass,
            request_method:    request_method,
            url:               url,
            query_param:       query_param
          )

          expect(web_vuln).to be_valid
        end
      end

      it "must not accept other values" do
        expect {
          described_class.new(
            type:              :lfi,
            lfi_filter_bypass: :other,
            request_method:    request_method,
            url:               url,
            query_param:       query_param
          )
        }.to raise_error(ArgumentError,"'other' is not a valid lfi_filter_bypass")
      end
    end

    describe "rfi_script_lang" do
      [
        nil,
        'asp',
        'asp_net',
        'cold_fusion',
        'jsp',
        'perl'
      ].each do |valid_rfi_script_lang|
        it "must accept #{valid_rfi_script_lang.inspect}" do
          web_vuln = described_class.new(
            type:            :rfi,
            rfi_script_lang: valid_rfi_script_lang,
            request_method:  request_method,
            url:             url,
            query_param:     query_param
          )

          expect(web_vuln).to be_valid
        end
      end

      it "must not accept other values" do
        expect {
          described_class.new(
            type:            :rfi,
            rfi_script_lang: :other,
            request_method:  request_method,
            url:             url,
            query_param:     query_param
          )
        }.to raise_error(ArgumentError,"'other' is not a valid rfi_script_lang")
      end
    end

    describe "ssti_escape_type" do
      [
        nil,
        'double_curly_braces',
        'dollar_curly_braces',
        'dollar_double_curly_braces',
        'pound_curly_braces',
        'angle_brackets_percent',
        'custom'
      ].each do |valid_ssti_escape_type|
        it "must accept #{valid_ssti_escape_type.inspect}" do
          web_vuln = described_class.new(
            type:             :ssti,
            ssti_escape_type: valid_ssti_escape_type,
            request_method:   request_method,
            url:              url,
            query_param:      query_param
          )

          expect(web_vuln).to be_valid
        end
      end

      it "must not accept other values" do
        expect {
          described_class.new(
            type:             :ssti,
            ssti_escape_type: :other,
            request_method:   request_method,
            url:              url,
            query_param:      query_param
          )
        }.to raise_error(ArgumentError,"'other' is not a valid ssti_escape_type")
      end
    end
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

  describe "#lfi?" do
    context "when #type is :lfi" do
      let(:type) { :lfi }

      it "must return true" do
        expect(subject.lfi?).to be(true)
      end
    end

    context "when #type is not :lfi" do
      let(:type) { :command_injection }

      it "must return false" do
        expect(subject.lfi?).to be(false)
      end
    end
  end

  describe "#rfi?" do
    context "when #type is :rfi" do
      let(:type) { :rfi }

      it "must return true" do
        expect(subject.rfi?).to be(true)
      end
    end

    context "when #type is not :rfi" do
      let(:type) { :command_injection }

      it "must return false" do
        expect(subject.rfi?).to be(false)
      end
    end
  end

  describe "#sqli?" do
    context "when #type is :sqli" do
      let(:type) { :sqli }

      it "must return true" do
        expect(subject.sqli?).to be(true)
      end
    end

    context "when #type is not :sqli" do
      let(:type) { :command_injection }

      it "must return false" do
        expect(subject.sqli?).to be(false)
      end
    end
  end

  describe "#ssti?" do
    context "when #type is :ssti" do
      let(:type) { :ssti }

      it "must return true" do
        expect(subject.ssti?).to be(true)
      end
    end

    context "when #type is not :ssti" do
      let(:type) { :command_injection }

      it "must return false" do
        expect(subject.ssti?).to be(false)
      end
    end
  end

  describe "#open_redirect?" do
    context "when #type is :open_redirect" do
      let(:type) { :open_redirect }

      it "must return true" do
        expect(subject.open_redirect?).to be(true)
      end
    end

    context "when #type is not :open_redirect" do
      let(:type) { :command_injection }

      it "must return false" do
        expect(subject.open_redirect?).to be(false)
      end
    end
  end

  describe "#reflected_xss?" do
    context "when #type is :reflected_xss" do
      let(:type) { :reflected_xss }

      it "must return true" do
        expect(subject.reflected_xss?).to be(true)
      end
    end

    context "when #type is not :reflected_xss" do
      let(:type) { :command_injection }

      it "must return false" do
        expect(subject.reflected_xss?).to be(false)
      end
    end
  end

  describe "#command_injection?" do
    context "when #type is :command_injection" do
      let(:type) { :command_injection }

      it "must return true" do
        expect(subject.command_injection?).to be(true)
      end
    end

    context "when #type is not :command_injection" do
      let(:type) { :lfi }

      it "must return false" do
        expect(subject.command_injection?).to be(false)
      end
    end
  end
end
