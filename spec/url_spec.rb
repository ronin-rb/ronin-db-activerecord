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

  describe ".http" do
    subject { described_class }

    before do
      http_scheme  = Ronin::DB::URLScheme.create(name: 'http')
      https_scheme = Ronin::DB::URLScheme.create(name: 'https')

      host = Ronin::DB::HostName.create(name: 'example.com')

      port_80  = Ronin::DB::Port.create(number: 80)
      port_443 = Ronin::DB::Port.create(number: 443)

      described_class.create(
        scheme:    http_scheme,
        host_name: host,
        port:      port_80,
        path:      '/'
      )

      described_class.create(
        scheme:    https_scheme,
        host_name: host,
        port:      port_443,
        path:      '/'
      )
    end

    it "must query all #{described_class} with the 'http' scheme" do
      urls = subject.http

      expect(urls).to_not be_empty
      expect(urls.map { |url| url.scheme.name }.uniq).to eq(['http'])
    end

    after do
      described_class.destroy_all
      Ronin::DB::URLScheme.destroy_all
      Ronin::DB::HostName.destroy_all
      Ronin::DB::Port.destroy_all
    end
  end

  describe ".https" do
    subject { described_class }

    before do
      http_scheme  = Ronin::DB::URLScheme.create(name: 'http')
      https_scheme = Ronin::DB::URLScheme.create(name: 'https')

      host = Ronin::DB::HostName.create(name: 'example.com')

      port_80  = Ronin::DB::Port.create(number: 80)
      port_443 = Ronin::DB::Port.create(number: 443)

      described_class.create(
        scheme:    http_scheme,
        host_name: host,
        port:      port_80,
        path:      '/'
      )

      described_class.create(
        scheme:    https_scheme,
        host_name: host,
        port:      port_443,
        path:      '/'
      )
    end

    it "must query all #{described_class} with the 'https' scheme" do
      urls = subject.https

      expect(urls).to_not be_empty
      expect(urls.map { |url| url.scheme.name }.uniq).to eq(['https'])
    end

    after do
      described_class.destroy_all
      Ronin::DB::URLScheme.destroy_all
      Ronin::DB::HostName.destroy_all
      Ronin::DB::Port.destroy_all
    end
  end

  describe ".with_host_name" do
    subject { described_class }

    let(:host_name1) { 'example1.com' }
    let(:host_name2) { 'example2.com' }

    before do
      http_scheme = Ronin::DB::URLScheme.create(name: 'http')

      host1 = Ronin::DB::HostName.create(name: host_name1)
      host2 = Ronin::DB::HostName.create(name: host_name2)

      port_80 = Ronin::DB::Port.create(number: 443)

      described_class.create(
        scheme:    http_scheme,
        host_name: host1,
        port:      port_80,
        path:      '/'
      )

      described_class.create(
        scheme:    http_scheme,
        host_name: host2,
        port:      port_80,
        path:      '/'
      )

      described_class.create(
        scheme:    http_scheme,
        host_name: host1,
        port:      port_80,
        path:      '/other'
      )
    end

    it "must query all #{described_class} with the matching host name" do
      urls = subject.with_host_name(host_name1)

      expect(urls).to_not be_empty
      expect(urls.map { |url| url.host_name.name }.uniq).to eq([host_name1])
    end

    after do
      described_class.destroy_all
      Ronin::DB::URLScheme.destroy_all
      Ronin::DB::HostName.destroy_all
      Ronin::DB::Port.destroy_all
    end
  end

  describe ".with_port_number" do
    subject { described_class }

    let(:port_number1) { 80  }
    let(:port_number2) { 443 }

    before do
      http_scheme = Ronin::DB::URLScheme.create(name: 'http')
      host        = Ronin::DB::HostName.create(name: 'example.com')

      port1 = Ronin::DB::Port.create(number: port_number1)
      port2 = Ronin::DB::Port.create(number: port_number2)

      described_class.create(
        scheme:    http_scheme,
        host_name: host,
        port:      port1,
        path:      '/'
      )

      described_class.create(
        scheme:    http_scheme,
        host_name: host,
        port:      port2,
        path:      '/'
      )

      described_class.create(
        scheme:    http_scheme,
        host_name: host,
        port:      port1,
        path:      '/other'
      )
    end

    it "must query all #{described_class} with the matching port number" do
      urls = subject.with_port_number(port_number1)

      expect(urls).to_not be_empty
      expect(urls.map { |url| url.port.number }.uniq).to eq([port_number1])
    end

    after do
      described_class.destroy_all
      Ronin::DB::URLScheme.destroy_all
      Ronin::DB::HostName.destroy_all
      Ronin::DB::Port.destroy_all
    end
  end

  describe ".with_directory" do
    subject { described_class }

    let(:dir) { '/dir' }

    before do
      http_scheme = Ronin::DB::URLScheme.create(name: 'http')
      host        = Ronin::DB::HostName.create(name: 'example.com')
      port        = Ronin::DB::Port.create(number: 80)

      described_class.create(
        scheme:    http_scheme,
        host_name: host,
        port:      port,
        path:      "#{dir}/foo"
      )

      described_class.create(
        scheme:    http_scheme,
        host_name: host,
        port:      port,
        path:      '/'
      )

      described_class.create(
        scheme:    http_scheme,
        host_name: host,
        port:      port,
        path:      "#{dir}/bar"
      )
    end

    it "must query all #{described_class} with the common directory" do
      urls = subject.with_directory(dir)

      expect(urls).to_not be_empty
      expect(urls.map(&:path)).to all(start_with(dir))
    end

    after do
      described_class.destroy_all
      Ronin::DB::URLScheme.destroy_all
      Ronin::DB::HostName.destroy_all
      Ronin::DB::Port.destroy_all
    end
  end

  describe ".with_basename" do
    subject { described_class }

    let(:dir)      { '/dir' }
    let(:basename) { 'base' }

    before do
      http_scheme = Ronin::DB::URLScheme.create(name: 'http')
      host        = Ronin::DB::HostName.create(name: 'example.com')
      port        = Ronin::DB::Port.create(number: 80)

      described_class.create(
        scheme:    http_scheme,
        host_name: host,
        port:      port,
        path:      "#{dir}/foo"
      )

      described_class.create(
        scheme:    http_scheme,
        host_name: host,
        port:      port,
        path:      "#{dir}/#{basename}"
      )

      described_class.create(
        scheme:    http_scheme,
        host_name: host,
        port:      port,
        path:      "#{dir}/bar"
      )
    end

    it "must query all #{described_class} with the common base name" do
      urls = subject.with_basename(basename)

      expect(urls).to_not be_empty
      expect(urls.map(&:path)).to all(end_with("/#{basename}"))
    end

    after do
      described_class.destroy_all
      Ronin::DB::URLScheme.destroy_all
      Ronin::DB::HostName.destroy_all
      Ronin::DB::Port.destroy_all
    end
  end

  describe ".with_file_ext" do
    subject { described_class }

    let(:ext) { 'xml' }

    before do
      http_scheme = Ronin::DB::URLScheme.create(name: 'http')
      host        = Ronin::DB::HostName.create(name: 'example.com')
      port        = Ronin::DB::Port.create(number: 80)

      described_class.create(
        scheme:    http_scheme,
        host_name: host,
        port:      port,
        path:      "/foo.#{ext}"
      )

      described_class.create(
        scheme:    http_scheme,
        host_name: host,
        port:      port,
        path:      '/foo.txt'
      )

      described_class.create(
        scheme:    http_scheme,
        host_name: host,
        port:      port,
        path:      "/bar.#{ext}"
      )
    end

    it "must query all #{described_class} with the matching file extension" do
      urls = subject.with_file_ext(ext)

      expect(urls).to_not be_empty
      expect(urls.map(&:path)).to all(end_with(".#{ext}"))
    end

    after do
      described_class.destroy_all
      Ronin::DB::URLScheme.destroy_all
      Ronin::DB::HostName.destroy_all
      Ronin::DB::Port.destroy_all
    end
  end

  describe ".with_query_param" do
    subject { described_class }

    let(:name)  { 'id' }
    let(:value) { '2'  }

    before do
      http_scheme = Ronin::DB::URLScheme.create(name: 'http')
      host        = Ronin::DB::HostName.create(name: 'example.com')
      port        = Ronin::DB::Port.create(number: 80)

      query_param_name1 = Ronin::DB::URLQueryParamName.create(name: 'foo')
      query_param_name2 = Ronin::DB::URLQueryParamName.create(name: name)
      query_param_name3 = Ronin::DB::URLQueryParamName.create(name: 'bar')

      described_class.create(
        scheme:    http_scheme,
        host_name: host,
        port:      port,
        path:      '/foo',
        query_params: [
          Ronin::DB::URLQueryParam.new(
            name:  query_param_name1,
            value: 'abc'
          )
        ]
      )

      described_class.create(
        scheme:    http_scheme,
        host_name: host,
        port:      port,
        path:      '/bar',
        query_params: [
          Ronin::DB::URLQueryParam.new(
            name:  query_param_name2,
            value: value
          )
        ]
      )

      described_class.create(
        scheme:    http_scheme,
        host_name: host,
        port:      port,
        path:      '/baz',
        query_params: [
          Ronin::DB::URLQueryParam.new(
            name:  query_param_name3,
            value: 'xyz'
          )
        ]
      )
      described_class.create(
        scheme:    http_scheme,
        host_name: host,
        port:      port,
        path:      '/qux',
        query_params: [
          Ronin::DB::URLQueryParam.new(
            name:  query_param_name2,
            value: value
          )
        ]
      )

    end

    it "must query all #{described_class} with the matching query_param name and value" do
      urls = subject.with_query_param(name,value)

      expect(urls).to_not be_empty
      expect(
        urls.flat_map(&:query_params).map { |param|
          [param.name.name, param.value] 
        }.uniq
      ).to eq([ [name, value] ])
    end

    after do
      described_class.destroy_all
      Ronin::DB::URLQueryParamName.destroy_all
      Ronin::DB::URLScheme.destroy_all
      Ronin::DB::HostName.destroy_all
      Ronin::DB::Port.destroy_all
    end
  end

  describe ".with_query_param_name" do
    subject { described_class }

    let(:name)   { 'id' }
    let(:value1) { 'A'  }
    let(:value2) { 'B'  }

    before do
      http_scheme = Ronin::DB::URLScheme.create(name: 'http')
      host        = Ronin::DB::HostName.create(name: 'example.com')
      port        = Ronin::DB::Port.create(number: 80)

      query_param_name1 = Ronin::DB::URLQueryParamName.create(name: 'foo')
      query_param_name2 = Ronin::DB::URLQueryParamName.create(name: name)
      query_param_name3 = Ronin::DB::URLQueryParamName.create(name: 'bar')

      described_class.create(
        scheme:    http_scheme,
        host_name: host,
        port:      port,
        path:      '/foo',
        query_params: [
          Ronin::DB::URLQueryParam.new(
            name:  query_param_name1,
            value: 'abc'
          )
        ]
      )

      described_class.create(
        scheme:    http_scheme,
        host_name: host,
        port:      port,
        path:      '/bar',
        query_params: [
          Ronin::DB::URLQueryParam.new(
            name:  query_param_name2,
            value: value1
          )
        ]
      )

      described_class.create(
        scheme:    http_scheme,
        host_name: host,
        port:      port,
        path:      '/baz',
        query_params: [
          Ronin::DB::URLQueryParam.new(
            name:  query_param_name3,
            value: 'xyz'
          )
        ]
      )
      described_class.create(
        scheme:    http_scheme,
        host_name: host,
        port:      port,
        path:      '/qux',
        query_params: [
          Ronin::DB::URLQueryParam.new(
            name:  query_param_name2,
            value: value2
          )
        ]
      )

    end

    it "must query all #{described_class} with the matching query_param name" do
      urls = subject.with_query_param_name(name)

      expect(urls).to_not be_empty
      expect(
        urls.flat_map(&:query_params).map { |param|
          [param.name.name, param.value] 
        }.uniq
      ).to eq([ [name, value1], [name, value2] ])
    end

    after do
      described_class.destroy_all
      Ronin::DB::URLQueryParamName.destroy_all
      Ronin::DB::URLScheme.destroy_all
      Ronin::DB::HostName.destroy_all
      Ronin::DB::Port.destroy_all
    end
  end

  describe ".with_query_param_name" do
    subject { described_class }

    let(:name1)  { 'id1' }
    let(:name2)  { 'id2' }
    let(:value) { 'foo' }

    before do
      http_scheme = Ronin::DB::URLScheme.create(name: 'http')
      host        = Ronin::DB::HostName.create(name: 'example.com')
      port        = Ronin::DB::Port.create(number: 80)

      query_param_name1 = Ronin::DB::URLQueryParamName.create(name: 'a')
      query_param_name2 = Ronin::DB::URLQueryParamName.create(name: name1)
      query_param_name3 = Ronin::DB::URLQueryParamName.create(name: 'b')
      query_param_name4 = Ronin::DB::URLQueryParamName.create(name: name2)

      described_class.create(
        scheme:    http_scheme,
        host_name: host,
        port:      port,
        path:      '/foo',
        query_params: [
          Ronin::DB::URLQueryParam.new(
            name:  query_param_name1,
            value: 'abc'
          )
        ]
      )

      described_class.create(
        scheme:    http_scheme,
        host_name: host,
        port:      port,
        path:      '/bar',
        query_params: [
          Ronin::DB::URLQueryParam.new(
            name:  query_param_name2,
            value: value
          )
        ]
      )

      described_class.create(
        scheme:    http_scheme,
        host_name: host,
        port:      port,
        path:      '/baz',
        query_params: [
          Ronin::DB::URLQueryParam.new(
            name:  query_param_name3,
            value: 'xyz'
          )
        ]
      )
      described_class.create(
        scheme:    http_scheme,
        host_name: host,
        port:      port,
        path:      '/qux',
        query_params: [
          Ronin::DB::URLQueryParam.new(
            name:  query_param_name4,
            value: value
          )
        ]
      )

    end

    it "must query all #{described_class} with the matching query_param value" do
      urls = subject.with_query_param_value(value)

      expect(urls).to_not be_empty
      expect(
        urls.flat_map(&:query_params).map { |param|
          [param.name.name, param.value] 
        }.uniq
      ).to eq([ [name1, value], [name2, value] ])
    end

    after do
      described_class.destroy_all
      Ronin::DB::URLQueryParamName.destroy_all
      Ronin::DB::URLScheme.destroy_all
      Ronin::DB::HostName.destroy_all
      Ronin::DB::Port.destroy_all
    end
  end

  describe ".lookup" do
    subject { described_class }

    let(:scheme) { 'https' }
    let(:host)   { 'example.com' }
    let(:port)   { 443 }
    let(:path)   { '/path' }

    before do
      http_scheme  = Ronin::DB::URLScheme.create(name: 'http')
      https_scheme = Ronin::DB::URLScheme.create(name: scheme)

      host1 = Ronin::DB::HostName.create(name: 'example1.com')
      host2 = Ronin::DB::HostName.create(name: host)
      host3 = Ronin::DB::HostName.create(name: 'example2.com')

      port_80  = Ronin::DB::Port.create(number: 80)
      port_443 = Ronin::DB::Port.create(number: port)

      path1 = '/foo'
      path2 = path
      path3 = '/bar'

      described_class.create(
        scheme:    http_scheme,
        host_name: host1,
        port:      port_80,
        path:      path1
      )

      described_class.create(
        scheme:    https_scheme,
        host_name: host2,
        port:      port_443,
        path:      path2
      )

      described_class.create(
        scheme:    https_scheme,
        host_name: host3,
        port:      port_443,
        path:      path3
      )
    end

    let(:uri) do
      URI::HTTPS.build(
        scheme: scheme,
        host:   host,
        port:   port,
        path:   path
      )
    end

    context "when given a URI object" do
      it "must find the #{described_class} with the URI's scheme, host, port, and path" do
        url = subject.lookup(uri)

        expect(url).to_not be(nil)
        expect(url.to_uri).to eq(uri)
      end
    end

    context "when given a String" do
      let(:string) { uri.to_s }

      it "must parse the String before querying the #{described_class} with the URI's same scheme, host, port, and path" do
        url = subject.lookup(string)

        expect(url).to_not be(nil)
        expect(url.to_uri).to eq(uri)
      end
    end

    after do
      described_class.destroy_all
      Ronin::DB::URLScheme.destroy_all
      Ronin::DB::HostName.destroy_all
      Ronin::DB::Port.destroy_all
    end
  end

  describe ".import" do
    context "when given a URI::HTTP object" do
      subject { described_class.import(uri) }

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

      context "when the URIs path is empty" do
        let(:uri) { URI('http://www.example.com') }

        it "must default the path to '/'" do
          expect(subject.path).to eq('/')
        end
      end
    end

    after do
      described_class.destroy_all
      Ronin::DB::URLScheme.destroy_all
      Ronin::DB::HostName.destroy_all
      Ronin::DB::Port.destroy_all
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
