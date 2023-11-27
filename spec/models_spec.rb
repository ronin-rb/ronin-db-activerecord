require 'spec_helper'

describe 'ronin/db/models' do
  it "must load all models" do
    expect(require('ronin/db/models')).to eq(true)
  end
end

describe 'Ronin::DB::Models' do
  before(:all) { require 'ronin/db/models' }

  subject { Ronin::DB::Models }

  describe "ALL" do
    subject { super()::ALL }

    it { expect(subject).to include(Ronin::DB::Arch) }
    it { expect(subject).to include(Ronin::DB::Credential) }
    it { expect(subject).to include(Ronin::DB::EmailAddress) }
    it { expect(subject).to include(Ronin::DB::HostName) }
    it { expect(subject).to include(Ronin::DB::HostNameIPAddress) }
    it { expect(subject).to include(Ronin::DB::IPAddress) }
    it { expect(subject).to include(Ronin::DB::IPAddressMACAddress) }
    it { expect(subject).to include(Ronin::DB::MACAddress) }
    it { expect(subject).to include(Ronin::DB::OS) }
    it { expect(subject).to include(Ronin::DB::OSGuess) }
    it { expect(subject).to include(Ronin::DB::OpenPort) }
    it { expect(subject).to include(Ronin::DB::Organization) }
    it { expect(subject).to include(Ronin::DB::Password) }
    it { expect(subject).to include(Ronin::DB::Person) }
    it { expect(subject).to include(Ronin::DB::PersonalPhoneNumber) }
    it { expect(subject).to include(Ronin::DB::PersonalEmailAddress) }
    it { expect(subject).to include(Ronin::DB::PersonalConnection) }
    it { expect(subject).to include(Ronin::DB::Port) }
    it { expect(subject).to include(Ronin::DB::Service) }
    it { expect(subject).to include(Ronin::DB::ServiceCredential) }
    it { expect(subject).to include(Ronin::DB::Software) }
    it { expect(subject).to include(Ronin::DB::URLQueryParamName) }
    it { expect(subject).to include(Ronin::DB::URLQueryParam) }
    it { expect(subject).to include(Ronin::DB::URLScheme) }
    it { expect(subject).to include(Ronin::DB::URL) }
    it { expect(subject).to include(Ronin::DB::WebVuln) }
    it { expect(subject).to include(Ronin::DB::UserName) }
    it { expect(subject).to include(Ronin::DB::SoftwareVendor) }
    it { expect(subject).to include(Ronin::DB::WebCredential) }
    it { expect(subject).to include(Ronin::DB::ASN) }
    it { expect(subject).to include(Ronin::DB::HTTPQueryParamName) }
    it { expect(subject).to include(Ronin::DB::HTTPQueryParam) }
    it { expect(subject).to include(Ronin::DB::HTTPHeaderName) }
    it { expect(subject).to include(Ronin::DB::HTTPRequestHeader) }
    it { expect(subject).to include(Ronin::DB::HTTPResponseHeader) }
    it { expect(subject).to include(Ronin::DB::HTTPRequest) }
    it { expect(subject).to include(Ronin::DB::HTTPResponse) }
    it { expect(subject).to include(Ronin::DB::CertName) }
    it { expect(subject).to include(Ronin::DB::CertIssuer) }
    it { expect(subject).to include(Ronin::DB::CertSubject) }
    it { expect(subject).to include(Ronin::DB::CertSubjectAltName) }
    it { expect(subject).to include(Ronin::DB::Cert) }
  end

  describe ".connect" do
    it "must call #connection on all MODELS" do
      subject::ALL.each do |model|
        expect(model).to receive(:connection)
      end

      subject.connect
    end
  end
end
