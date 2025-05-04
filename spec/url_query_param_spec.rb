require 'spec_helper'
require 'ronin/db/url_query_param'

describe Ronin::DB::URLQueryParam do
  it "must use the 'ronin_url_query_params' table" do
    expect(described_class.table_name).to eq('ronin_url_query_params')
  end

  let(:scheme) { 'https' }
  let(:host_name) { 'www.example.com' }
  let(:port) { 8080 }
  let(:path) { '/path' }
  let(:query_params) { {'q' => '1'} }
  let(:query_string) { 'q=1' }
  let(:fragment) { 'frag' }

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
    Ronin::DB::URLQueryParamName.find_or_initialize_by(name: name)
  end

  let(:url) do
    Ronin::DB::URL.new(
      scheme:       url_scheme,
      host_name:    url_host_name,
      port:         url_port,
      path:         path,
      fragment:     fragment
    )
  end

  let(:name)  { 'foo' }
  let(:value) { 'bar' }

  describe "validations" do
    describe "name" do
      it "must require a name association" do
        url_query_param = described_class.new(value: value)
        expect(url_query_param).to_not be_valid
        expect(url_query_param.errors[:name]).to eq(
          ["must exist"]
        )

        url_query_param = described_class.new(
          name:  url_query_param_name,
          value: value,
          url:   url
        )
        expect(url_query_param).to be_valid
      end
    end

    describe "url"
  end

  subject do
    described_class.new(
      name:  Ronin::DB::URLQueryParamName.new(name: name),
      value: value,
      url:   url
    )
  end

  describe "#to_s" do
    it "must dump a name and a value into a String" do
      expect(subject.to_s).to eq("#{name}=#{value}")
    end

    context "when an empty value" do
      let(:value) { '' }

      it "must ignore empty or nil values" do
        expect(subject.to_s).to eq("#{name}=")
      end
    end

    context "when a nil value" do
      let(:value) { nil }

      it "must ignore empty or nil values" do
        expect(subject.to_s).to eq("#{name}=")
      end
    end

    context "with special characters" do
      let(:value)         { 'bar baz' }
      let(:encoded_value) { URI::DEFAULT_PARSER.escape(value) }

      subject do
        described_class.new(
          name:  Ronin::DB::URLQueryParamName.new(name: name),
          value: value
        )
      end

      it "must escape special characters" do
        expect(subject.to_s).to eq("#{name}=#{encoded_value}")
      end
    end
  end
end
