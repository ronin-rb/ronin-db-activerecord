require 'spec_helper'
require 'ronin/db/url'

describe Ronin::DB::URL do
  it "must use the 'ronin_urls' table" do
    expect(described_class.table_name).to eq('ronin_urls')
  end

  let(:scheme) { 'https' }
  let(:host_name) { 'www.example.com' }
  let(:port) { 8080 }
  let(:path) { '/path' }
  let(:query_params) { {'q' => '1'} }
  let(:query) { 'q=1' }
  let(:fragment) { 'frag' }

  let(:uri) do
    URI::HTTPS.build(
      scheme:   scheme,
      host:     host_name,
      port:     port,
      path:     path,
      query:    query,
      fragment: fragment
    )
  end

  let(:url_scheme) do
    Ronin::DB::URLScheme.find_or_initialize_by(name: scheme)
  end
  let(:url_host_name) do
    Ronin::DB::HostName.find_or_initialize_by(name: host_name)
  end
  let(:url_port) do
    Ronin::DB::Port.find_or_initialize_by(protocol: :tcp, number: port)
  end
  let(:url_query_param_name) do
    Ronin::DB::URLQueryParamName.find_or_initialize_by(
      name: query_params.keys[0]
    )
  end
  let(:url_query_param) do
    Ronin::DB::URLQueryParam.new(
      name:  url_query_param_name,
      value: query_params.values[0]
    )
  end

  subject do
    described_class.new(
      scheme:       url_scheme,
      host_name:    url_host_name,
      port:         url_port,
      path:         path,
      query:        query,
      fragment:     fragment,
      query_params: [url_query_param]
    )
  end

  describe ".from" do
    subject { described_class.from(uri) }

    it "should parse URL schemes" do
      expect(subject.scheme).not_to be_nil
      expect(subject.scheme.name).to be == scheme
    end

    it "should parse host names" do
      expect(subject.host_name.name).to be == host_name
    end

    it "should parse port numbers" do
      expect(subject.port.number).to be == port
    end

    it "should parse paths" do
      expect(subject.path).to be == path
    end

    it "should parse query strings" do
      expect(subject.query).to be == query
    end

    it "should parse URL fragments" do
      expect(subject.fragment).to be == fragment
    end

    it "should normalize the paths of HTTP URIs" do
      uri = URI('http://www.example.com')
      url = described_class.from(uri)

      expect(url.path).to be == '/'
    end
  end

  describe "#host" do
    subject do
      described_class.new(host_name: url_host_name)
    end

    it "should return the URI host String" do
      expect(subject.host).to be == host_name
    end
  end

  describe "#to_uri" do
    subject { super().to_uri }

    it "should convert the scheme" do
      expect(subject.scheme).to be == scheme
    end
    
    it "should convert the host name" do
      expect(subject.host).to be == host_name
    end

    it "should convert the port number" do
      expect(subject.port).to be == port
    end

    it "should convert the path" do
      expect(subject.path).to be == path
    end

    it "should convert the query string" do
      expect(subject.query).to be == query
    end

    it "should omit the query string if there are no query params" do
      new_url = described_class.parse('https://www.example.com:8080/path')
      new_uri = new_url.to_uri

      expect(new_uri.query).to be_nil
    end

    it "should convert the fragment" do
      expect(subject.fragment).to be == fragment
    end
  end

  describe "#to_s" do
    it "should convert the URL back into a String URI" do
      expect(subject.to_s).to be == uri.to_s
    end
  end
end
