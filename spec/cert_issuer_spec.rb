require 'spec_helper'
require 'ronin/db/cert_issuer'

require 'openssl'

describe Ronin::DB::CertIssuer do
  it "must use the 'ronin_cert_issuers' table" do
    expect(described_class.table_name).to eq('ronin_cert_issuers')
  end

  let(:common_name)         { 'Test CA' }
  let(:email_address)       { 'admin@test-ca.com' }
  let(:organization)        { 'Test CA, Inc.' }
  let(:organizational_unit) { 'CA Dept' }
  let(:locality)            { 'CA City' }
  let(:state)               { 'NY' }
  let(:country)             { 'US' }

  describe ".import" do
    let(:x509_issuer) { OpenSSL::X509::Name.new }

    before do
      x509_issuer.add_entry('CN',common_name)
      x509_issuer.add_entry('emailAddress',email_address)
      x509_issuer.add_entry('O',organization)
      x509_issuer.add_entry('OU',organizational_unit)
      x509_issuer.add_entry('L',locality)
      x509_issuer.add_entry('ST',state)
      x509_issuer.add_entry('C',country)
    end

    subject { described_class.import(x509_issuer) }

    it "must import the X509 issuer information and return a new #{described_class} record" do
      expect(subject).to be_kind_of(described_class)
      expect(subject.id).to_not be(nil)
      expect(subject.common_name).to eq(common_name)
      expect(subject.email_address).to eq(email_address)
      expect(subject.organization).to eq(organization)
      expect(subject.organizational_unit).to eq(organizational_unit)
      expect(subject.locality).to eq(locality)
      expect(subject.state).to eq(state)
      expect(subject.country).to eq(country)
    end

    after { described_class.destroy_all }
  end

  describe "validations" do
    it "must require an #organization" do
      cert_issuer = described_class.new(common_name: 'Test', country: 'US')

      expect(cert_issuer).to_not be_valid
      expect(cert_issuer.errors[:organization]).to include("can't be blank")
    end

    it "must require a #country" do
      cert_issuer = described_class.new(common_name: 'Test', organization: 'Test')

      expect(cert_issuer).to_not be_valid
      expect(cert_issuer.errors[:country]).to include("can't be blank")
    end

    it "must require a two-letter #country code" do
      cert_issuer = described_class.new(common_name: 'Test', organization: 'Test', country: 'XYZ')

      expect(cert_issuer).to_not be_valid
      expect(cert_issuer.errors[:country]).to include(
        "is the wrong length (should be 2 characters)"
      )
    end

    it "must require a unique #common_name, #organization, #organizational_unit, #locality, #state, and #country" do
      described_class.create(
        common_name:         'Test',
        organization:        'Test',
        organizational_unit: 'Test Dept',
        locality:            'Testville',
        state:               'CA',
        country:             'US'
      )

      cert_issuer = described_class.new(
        common_name:         'Test',
        organization:        'Test',
        organizational_unit: 'Test Dept',
        locality:            'Testville',
        state:               'CA',
        country:             'US'
      )

      expect(cert_issuer).to_not be_valid
      expect(cert_issuer.errors[:common_name]).to include(
        "has already been taken"
      )

      described_class.destroy_all
    end
  end
end
