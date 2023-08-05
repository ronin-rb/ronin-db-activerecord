require 'spec_helper'
require 'ronin/db/cert_subject'

describe Ronin::DB::CertSubject do
  it "must use the 'ronin_cert_subjects' table" do
    expect(described_class.table_name).to eq('ronin_cert_subjects')
  end

  let(:common_name)         { 'example.com' }
  let(:email_address)       { 'admin@example.com' }
  let(:organization)        { 'Example Co.' }
  let(:organizational_unit) { 'Example Dept.' }
  let(:locality)            { 'Example City' }
  let(:state)               { 'NY' }
  let(:country)             { 'US' }

  describe ".import" do
    let(:x509_subject) { OpenSSL::X509::Name.new }

    before do
      x509_subject.add_entry('CN',common_name)
      x509_subject.add_entry('emailAddress',email_address)
      x509_subject.add_entry('O',organization)
      x509_subject.add_entry('OU',organizational_unit)
      x509_subject.add_entry('L',locality)
      x509_subject.add_entry('ST',state)
      x509_subject.add_entry('C',country)
    end

    subject { described_class.import(x509_subject) }

    it "must import the X509 issuer information and return a new #{described_class} record" do
      expect(subject).to be_kind_of(described_class)
      expect(subject.id).to_not be(nil)
      expect(subject.common_name).to be_kind_of(Ronin::DB::CertName)
      expect(subject.common_name.id).to_not be(nil)
      expect(subject.common_name.name).to eq(common_name)
      expect(subject.email_address).to eq(email_address)
      expect(subject.organization).to eq(organization)
      expect(subject.organizational_unit).to eq(organizational_unit)
      expect(subject.locality).to eq(locality)
      expect(subject.state).to eq(state)
      expect(subject.country).to eq(country)
    end

    after do
      Ronin::DB::CertSubject.destroy_all
      Ronin::DB::CertName.destroy_all
    end
  end

  describe "validations" do
    let(:common_name) { Ronin::DB::CertName.create(name: 'example.com') }

    it "must require an #organization" do
      cert_subject = described_class.new(
        common_name: common_name,
        country:     'US'
      )

      expect(cert_subject).to_not be_valid
      expect(cert_subject.errors[:organization]).to include("can't be blank")
    end

    it "must require a #country" do
      cert_subject = described_class.new(
        common_name:  common_name,
        organization: 'Example'
      )

      expect(cert_subject).to_not be_valid
      expect(cert_subject.errors[:country]).to include("can't be blank")
    end

    it "must require a two-letter #country code" do
      cert_subject = described_class.new(
        common_name:  common_name,
        organization: 'Example',
        country:      'XYZ'
      )

      expect(cert_subject).to_not be_valid
      expect(cert_subject.errors[:country]).to include(
        "is the wrong length (should be 2 characters)"
      )
    end

    it "must require a unique #common_name, #organization, #organizational_unit, #locality, #state, and #country" do
      described_class.create(
        common_name:         common_name,
        organization:        'Example',
        organizational_unit: 'Example Dept',
        locality:            'Exampleville',
        state:               'CA',
        country:             'US'
      )

      cert_subject = described_class.new(
        common_name:         common_name,
        organization:        'Example',
        organizational_unit: 'Example Dept',
        locality:            'Exampleville',
        state:               'CA',
        country:             'US'
      )

      expect(cert_subject).to_not be_valid
      expect(cert_subject.errors[:common_name]).to include(
        "has already been taken"
      )

      described_class.destroy_all
    end

    after { common_name.destroy }
  end
end
