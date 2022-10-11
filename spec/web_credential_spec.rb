require 'spec_helper'
require 'ronin/db/web_credential'

describe Ronin::DB::WebCredential do
  it "must use the 'ronin_web_credentials' table" do
    expect(described_class.table_name).to eq('ronin_web_credentials')
  end

  let(:scheme) { 'https' }
  let(:host_name) { 'www.example.com' }
  let(:port) { 8080 }
  let(:path) { '/path' }
  let(:query_params) { {'q' => '1'} }
  let(:query) { 'q=1' }
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
  let(:url) do
    Ronin::DB::URL.new(
      scheme:       url_scheme,
      host_name:    url_host_name,
      port:         url_port,
      path:         path,
      query:        query,
      fragment:     fragment,
      query_params: [url_query_param]
    )
  end

  let(:user_name) { Ronin::DB::UserName.new(name: 'admin') }
  let(:password)  { Ronin::DB::Password.new(plain_text: 'secret') }
  let(:credential) do
    Ronin::DB::Credential.new(
      user_name: user_name,
      password:  password
    )
  end

  subject do
    described_class.new(
      credential: credential,
      url:        url
    )
  end

  describe "#to_s" do
    it "must include user:password and the URL in the String" do
      expect(subject.to_s).to eq(
        "#{user_name}:#{password} (#{url})"
      )
    end
  end
end
