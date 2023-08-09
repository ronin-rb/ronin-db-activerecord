require 'spec_helper'
require 'ronin/db/cert'

describe Ronin::DB::Cert do
  let(:fixtures_dir) { File.join(__dir__,'fixtures','certs') }
  let(:cert_file)    { 'cert.crt' }
  let(:cert_path)    { File.join(fixtures_dir,cert_file) }
  let(:cert)         { OpenSSL::X509::Certificate.new(File.read(cert_path)) }

  let(:serial)  { rand(1_000_000..100_000_000) }
  let(:version) { 2 }

  let(:one_hour)   { 60 * 60 }
  let(:one_day)    { one_hour * 24 }
  let(:one_year)   { one_day * 365 }
  let(:not_before) { Time.now - one_year }
  let(:not_after)  { Time.now + one_year }

  let(:public_key_algorithm) { :rsa }
  let(:public_key_size)      { 4096 }

  let(:signing_algorithm) { 'sha256WithRSAEncryption' }

  let(:sha1_fingerprint)   { '3d810821a20e4ad5893281a245a9d767aff25419' }
  let(:sha256_fingerprint) { '45062d640b6db6d0ea9bc0e1b45025b0cc7a1da5417d8f01ab1d538b27021912' }

  let(:pem) { File.read(cert_path) }

  describe ".active" do
    subject { described_class }

    before do
      # active cert
      described_class.create(
        serial:  serial,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'test1.com'),
          organization:        'Test Co.',
          organizational_unit: 'Test Dept',
          locality:            'Test City',
          state:               'NY',
          country:             'US'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #2"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #2"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #2
          -----END CERTIFICATE-----
        PEM
      )

      # expired cert
      described_class.create(
        serial:  serial + 1,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now - one_day,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'expired.com'),
          organization:        'Expired Co.',
          organizational_unit: 'Expired Dept',
          locality:            'Expired City',
          state:               'NY',
          country:             'US'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #1"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #1"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #1
          -----END CERTIFICATE-----
        PEM
      )

      # active cert
      described_class.create(
        serial:  serial + 2,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'test2.com'),
          organization:        'Test Co.',
          organizational_unit: 'Test Dept',
          locality:            'Test City',
          state:               'NY',
          country:             'US'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #3"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #3"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #3
          -----END CERTIFICATE-----
        PEM
      )
    end

    it "must query all #{described_class} where #not_before is before Time.now, and #not_after is after Time.now" do
      certs = subject.active

      expect(certs.length).to eq(2)

      expect(certs[0].subject).to be_kind_of(Ronin::DB::CertSubject)
      expect(certs[0].subject.common_name).to be_kind_of(Ronin::DB::CertName)
      expect(certs[0].subject.common_name.name).to eq('test1.com')

      expect(certs[1].subject).to be_kind_of(Ronin::DB::CertSubject)
      expect(certs[1].subject.common_name).to be_kind_of(Ronin::DB::CertName)
      expect(certs[1].subject.common_name.name).to eq('test2.com')
    end

    after do
      Ronin::DB::Cert.destroy_all
      Ronin::DB::CertSubjectAltName.destroy_all
      Ronin::DB::CertIssuer.destroy_all
      Ronin::DB::CertSubject.destroy_all
      Ronin::DB::CertName.destroy_all
    end
  end

  describe ".expired" do
    subject { described_class }

    before do
      # expired cert
      described_class.create(
        serial:  serial,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now - one_day,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'expired1.com'),
          organization:        'Expired Co.',
          organizational_unit: 'Expired Dept',
          locality:            'Expired City',
          state:               'NY',
          country:             'US'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #1"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #1"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #1
          -----END CERTIFICATE-----
        PEM
      )

      # active cert
      described_class.create(
        serial:  serial + 1,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_day,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'test.com'),
          organization:        'Test Co.',
          organizational_unit: 'Test Dept',
          locality:            'Test City',
          state:               'NY',
          country:             'US'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #2"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #2"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #2
          -----END CERTIFICATE-----
        PEM
      )

      # expired cert
      described_class.create(
        serial:  serial + 2,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now - 1,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'expired2.com'),
          organization:        'Expired Co.',
          organizational_unit: 'Expired Dept',
          locality:            'Expired City',
          state:               'NY',
          country:             'US'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #3"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #3"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #3
          -----END CERTIFICATE-----
        PEM
      )
    end

    it "must query all #{described_class} where #not_after is before Time.now" do
      certs = subject.expired

      expect(certs.length).to eq(2)

      expect(certs[0].subject).to be_kind_of(Ronin::DB::CertSubject)
      expect(certs[0].subject.common_name).to be_kind_of(Ronin::DB::CertName)
      expect(certs[0].subject.common_name.name).to eq('expired1.com')

      expect(certs[1].subject).to be_kind_of(Ronin::DB::CertSubject)
      expect(certs[1].subject.common_name).to be_kind_of(Ronin::DB::CertName)
      expect(certs[1].subject.common_name.name).to eq('expired2.com')
    end

    after do
      Ronin::DB::Cert.destroy_all
      Ronin::DB::CertSubjectAltName.destroy_all
      Ronin::DB::CertIssuer.destroy_all
      Ronin::DB::CertSubject.destroy_all
      Ronin::DB::CertName.destroy_all
    end
  end

  describe ".with_issuer_common_name" do
    subject { described_class }

    before do
      issuer = Ronin::DB::CertIssuer.create(
        common_name:         'Test CA',
        email_address:       'admin@test-ca.com',
        organization:        'Test CA, Inc.',
        organizational_unit: 'CA Dept',
        locality:            'CA City',
        state:               'NY',
        country:             'US'
      )

      described_class.create(
        serial:  serial,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        issuer: issuer,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'test1.com'),
          organization:        'Test Co.',
          organizational_unit: 'Test Dept',
          locality:            'Test City',
          state:               'NY',
          country:             'US'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #1"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #1"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #1
          -----END CERTIFICATE-----
        PEM
      )

      described_class.create(
        serial:  serial + 1,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        issuer: Ronin::DB::CertIssuer.create(
          common_name:         'Other CA',
          email_address:       'admin@other-ca.com',
          organization:        'Other CA, Inc.',
          organizational_unit: 'Other CA Dept',
          locality:            'Other CA City',
          state:               'NY',
          country:             'US'
        ),

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'other.com'),
          organization:        'Other Co.',
          organizational_unit: 'Other Dept',
          locality:            'Other City',
          state:               'NY',
          country:             'US'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #2"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #2"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #2
          -----END CERTIFICATE-----
        PEM
      )

      described_class.create(
        serial:  serial + 2,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        issuer: issuer,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'test2.com'),
          organization:        'Test Co.',
          organizational_unit: 'Test Dept',
          locality:            'Test City',
          state:               'NY',
          country:             'US'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #3"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #3"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #3
          -----END CERTIFICATE-----
        PEM
      )
    end

    it "must query all #{described_class} with the matching issuer common name" do
      certs = subject.with_issuer_common_name('Test CA')

      expect(certs.length).to eq(2)

      expect(certs[0].issuer).to be_kind_of(Ronin::DB::CertIssuer)
      expect(certs[0].issuer.common_name).to eq('Test CA')

      expect(certs[1].issuer).to be_kind_of(Ronin::DB::CertIssuer)
      expect(certs[1].issuer.common_name).to eq('Test CA')
    end

    after do
      Ronin::DB::Cert.destroy_all
      Ronin::DB::CertSubjectAltName.destroy_all
      Ronin::DB::CertIssuer.destroy_all
      Ronin::DB::CertSubject.destroy_all
      Ronin::DB::CertName.destroy_all
    end
  end

  describe ".with_issuer_organization" do
    subject { described_class }

    before do
      issuer = Ronin::DB::CertIssuer.create(
        common_name:         'Test CA',
        email_address:       'admin@test-ca.com',
        organization:        'Test CA, Inc.',
        organizational_unit: 'CA Dept',
        locality:            'CA City',
        state:               'NY',
        country:             'US'
      )

      described_class.create(
        serial:  serial,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        issuer: issuer,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'test1.com'),
          organization:        'Test Co.',
          organizational_unit: 'Test Dept',
          locality:            'Test City',
          state:               'NY',
          country:             'US'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #1"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #1"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #1
          -----END CERTIFICATE-----
        PEM
      )

      described_class.create(
        serial:  serial + 1,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        issuer: Ronin::DB::CertIssuer.create(
          common_name:         'Other CA',
          email_address:       'admin@other-ca.com',
          organization:        'Other CA, Inc.',
          organizational_unit: 'Other CA Dept',
          locality:            'Other CA City',
          state:               'NY',
          country:             'US'
        ),

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'other.com'),
          organization:        'Other Co.',
          organizational_unit: 'Other Dept',
          locality:            'Other City',
          state:               'NY',
          country:             'US'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #2"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #2"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #2
          -----END CERTIFICATE-----
        PEM
      )

      described_class.create(
        serial:  serial + 2,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        issuer: issuer,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'test2.com'),
          organization:        'Test Co.',
          organizational_unit: 'Test Dept',
          locality:            'Test City',
          state:               'NY',
          country:             'US'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #3"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #3"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #3
          -----END CERTIFICATE-----
        PEM
      )
    end

    it "must query all #{described_class} with the matching issuer organization name" do
      certs = subject.with_issuer_organization('Test CA, Inc.')

      expect(certs.length).to eq(2)

      expect(certs[0].issuer).to be_kind_of(Ronin::DB::CertIssuer)
      expect(certs[0].issuer.organization).to eq('Test CA, Inc.')

      expect(certs[1].issuer).to be_kind_of(Ronin::DB::CertIssuer)
      expect(certs[1].issuer.organization).to eq('Test CA, Inc.')
    end

    after do
      Ronin::DB::Cert.destroy_all
      Ronin::DB::CertSubjectAltName.destroy_all
      Ronin::DB::CertIssuer.destroy_all
      Ronin::DB::CertSubject.destroy_all
      Ronin::DB::CertName.destroy_all
    end
  end

  describe ".with_issuer_organizational_unit" do
    subject { described_class }

    before do
      issuer = Ronin::DB::CertIssuer.create(
        common_name:         'Test CA',
        email_address:       'admin@test-ca.com',
        organization:        'Test CA, Inc.',
        organizational_unit: 'CA Dept',
        locality:            'CA City',
        state:               'NY',
        country:             'US'
      )

      described_class.create(
        serial:  serial,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        issuer: issuer,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'test1.com'),
          organization:        'Test Co.',
          organizational_unit: 'Test Dept',
          locality:            'Test City',
          state:               'NY',
          country:             'US'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #1"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #1"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #1
          -----END CERTIFICATE-----
        PEM
      )

      described_class.create(
        serial:  serial + 1,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        issuer: Ronin::DB::CertIssuer.create(
          common_name:         'Other CA',
          email_address:       'admin@other-ca.com',
          organization:        'Other CA, Inc.',
          organizational_unit: 'Other CA Dept',
          locality:            'Other CA City',
          state:               'NY',
          country:             'US'
        ),

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'other.com'),
          organization:        'Other Co.',
          organizational_unit: 'Other Dept',
          locality:            'Other City',
          state:               'NY',
          country:             'US'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #2"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #2"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #2
          -----END CERTIFICATE-----
        PEM
      )

      described_class.create(
        serial:  serial + 2,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        issuer: issuer,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'test2.com'),
          organization:        'Test Co.',
          organizational_unit: 'Test Dept',
          locality:            'Test City',
          state:               'NY',
          country:             'US'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #3"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #3"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #3
          -----END CERTIFICATE-----
        PEM
      )
    end

    it "must query all #{described_class} with the matching issuer organization unit name" do
      certs = subject.with_issuer_organizational_unit('CA Dept')

      expect(certs.length).to eq(2)

      expect(certs[0].issuer).to be_kind_of(Ronin::DB::CertIssuer)
      expect(certs[0].issuer.organizational_unit).to eq('CA Dept')

      expect(certs[1].issuer).to be_kind_of(Ronin::DB::CertIssuer)
      expect(certs[1].issuer.organizational_unit).to eq('CA Dept')
    end

    after do
      Ronin::DB::Cert.destroy_all
      Ronin::DB::CertSubjectAltName.destroy_all
      Ronin::DB::CertIssuer.destroy_all
      Ronin::DB::CertSubject.destroy_all
      Ronin::DB::CertName.destroy_all
    end
  end

  describe ".with_issuer_locality" do
    subject { described_class }

    before do
      issuer = Ronin::DB::CertIssuer.create(
        common_name:         'Test CA',
        email_address:       'admin@test-ca.com',
        organization:        'Test CA, Inc.',
        organizational_unit: 'CA Dept',
        locality:            'CA City',
        state:               'NY',
        country:             'US'
      )

      described_class.create(
        serial:  serial,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        issuer: issuer,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'test1.com'),
          organization:        'Test Co.',
          organizational_unit: 'Test Dept',
          locality:            'Test City',
          state:               'NY',
          country:             'US'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #1"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #1"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #1
          -----END CERTIFICATE-----
        PEM
      )

      described_class.create(
        serial:  serial + 1,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        issuer: Ronin::DB::CertIssuer.create(
          common_name:         'Other CA',
          email_address:       'admin@other-ca.com',
          organization:        'Other CA, Inc.',
          organizational_unit: 'Other CA Dept',
          locality:            'Other CA City',
          state:               'NY',
          country:             'US'
        ),

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'other.com'),
          organization:        'Other Co.',
          organizational_unit: 'Other Dept',
          locality:            'Other City',
          state:               'NY',
          country:             'US'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #2"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #2"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #2
          -----END CERTIFICATE-----
        PEM
      )

      described_class.create(
        serial:  serial + 2,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        issuer: issuer,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'test2.com'),
          organization:        'Test Co.',
          organizational_unit: 'Test Dept',
          locality:            'Test City',
          state:               'NY',
          country:             'US'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #3"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #3"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #3
          -----END CERTIFICATE-----
        PEM
      )
    end

    it "must query all #{described_class} with the matching issuer locality" do
      certs = subject.with_issuer_locality('CA City')

      expect(certs.length).to eq(2)

      expect(certs[0].issuer).to be_kind_of(Ronin::DB::CertIssuer)
      expect(certs[0].issuer.locality).to eq('CA City')

      expect(certs[1].issuer).to be_kind_of(Ronin::DB::CertIssuer)
      expect(certs[1].issuer.locality).to eq('CA City')
    end

    after do
      Ronin::DB::Cert.destroy_all
      Ronin::DB::CertSubjectAltName.destroy_all
      Ronin::DB::CertIssuer.destroy_all
      Ronin::DB::CertSubject.destroy_all
      Ronin::DB::CertName.destroy_all
    end
  end

  describe ".with_issuer_state" do
    subject { described_class }

    before do
      issuer = Ronin::DB::CertIssuer.create(
        common_name:         'Test CA',
        email_address:       'admin@test-ca.com',
        organization:        'Test CA, Inc.',
        organizational_unit: 'CA Dept',
        locality:            'CA City',
        state:               'NY',
        country:             'US'
      )

      described_class.create(
        serial:  serial,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        issuer: issuer,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'test1.com'),
          organization:        'Test Co.',
          organizational_unit: 'Test Dept',
          locality:            'Test City',
          state:               'NY',
          country:             'US'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #1"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #1"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #1
          -----END CERTIFICATE-----
        PEM
      )

      described_class.create(
        serial:  serial + 1,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        issuer: Ronin::DB::CertIssuer.create(
          common_name:         'Other CA',
          email_address:       'admin@other-ca.com',
          organization:        'Other CA, Inc.',
          organizational_unit: 'Other CA Dept',
          locality:            'Other CA City',
          state:               'XX',
          country:             'US'
        ),

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'other.com'),
          organization:        'Other Co.',
          organizational_unit: 'Other Dept',
          locality:            'Other City',
          state:               'XX',
          country:             'US'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #2"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #2"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #2
          -----END CERTIFICATE-----
        PEM
      )

      described_class.create(
        serial:  serial + 2,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        issuer: issuer,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'test2.com'),
          organization:        'Test Co.',
          organizational_unit: 'Test Dept',
          locality:            'Test City',
          state:               'NY',
          country:             'US'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #3"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #3"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #3
          -----END CERTIFICATE-----
        PEM
      )
    end

    it "must query all #{described_class} with the matching issuer state" do
      certs = subject.with_issuer_state('NY')

      expect(certs.length).to eq(2)

      expect(certs[0].issuer).to be_kind_of(Ronin::DB::CertIssuer)
      expect(certs[0].issuer.state).to eq('NY')

      expect(certs[1].issuer).to be_kind_of(Ronin::DB::CertIssuer)
      expect(certs[1].issuer.state).to eq('NY')
    end

    after do
      Ronin::DB::Cert.destroy_all
      Ronin::DB::CertSubjectAltName.destroy_all
      Ronin::DB::CertIssuer.destroy_all
      Ronin::DB::CertSubject.destroy_all
      Ronin::DB::CertName.destroy_all
    end
  end

  describe ".with_issuer_country" do
    subject { described_class }

    before do
      issuer = Ronin::DB::CertIssuer.create(
        common_name:         'Test CA',
        email_address:       'admin@test-ca.com',
        organization:        'Test CA, Inc.',
        organizational_unit: 'CA Dept',
        locality:            'CA City',
        state:               'NY',
        country:             'US'
      )

      described_class.create(
        serial:  serial,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        issuer: issuer,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'test1.com'),
          organization:        'Test Co.',
          organizational_unit: 'Test Dept',
          locality:            'Test City',
          state:               'NY',
          country:             'US'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #1"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #1"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #1
          -----END CERTIFICATE-----
        PEM
      )

      described_class.create(
        serial:  serial + 1,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        issuer: Ronin::DB::CertIssuer.create(
          common_name:         'Other CA',
          email_address:       'admin@other-ca.com',
          organization:        'Other CA, Inc.',
          organizational_unit: 'Other CA Dept',
          locality:            'Other CA City',
          state:               'XX',
          country:             'XX'
        ),

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'other.com'),
          organization:        'Other Co.',
          organizational_unit: 'Other Dept',
          locality:            'Other City',
          state:               'XX',
          country:             'XX'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #2"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #2"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #2
          -----END CERTIFICATE-----
        PEM
      )

      described_class.create(
        serial:  serial + 2,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        issuer: issuer,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'test2.com'),
          organization:        'Test Co.',
          organizational_unit: 'Test Dept',
          locality:            'Test City',
          state:               'NY',
          country:             'US'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #3"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #3"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #3
          -----END CERTIFICATE-----
        PEM
      )
    end

    it "must query all #{described_class} with the matching issuer country" do
      certs = subject.with_issuer_country('US')

      expect(certs.length).to eq(2)

      expect(certs[0].issuer).to be_kind_of(Ronin::DB::CertIssuer)
      expect(certs[0].issuer.country).to eq('US')

      expect(certs[1].issuer).to be_kind_of(Ronin::DB::CertIssuer)
      expect(certs[1].issuer.country).to eq('US')
    end

    after do
      Ronin::DB::Cert.destroy_all
      Ronin::DB::CertSubjectAltName.destroy_all
      Ronin::DB::CertIssuer.destroy_all
      Ronin::DB::CertSubject.destroy_all
      Ronin::DB::CertName.destroy_all
    end
  end

  describe ".with_organization" do
    subject { described_class }

    before do
      described_class.create(
        serial:  serial,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'test1.com'),
          organization:        'Test Co.',
          organizational_unit: 'Test Dept',
          locality:            'Test City',
          state:               'NY',
          country:             'US'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #1"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #1"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #1
          -----END CERTIFICATE-----
        PEM
      )

      described_class.create(
        serial:  serial + 1,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'other.com'),
          organization:        'Other Co.',
          organizational_unit: 'Other Dept',
          locality:            'Other City',
          state:               'XX',
          country:             'XX'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #2"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #2"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #2
          -----END CERTIFICATE-----
        PEM
      )

      described_class.create(
        serial:  serial + 2,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'test2.com'),
          organization:        'Test Co.',
          organizational_unit: 'Test Dept',
          locality:            'Test City',
          state:               'NY',
          country:             'US'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #3"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #3"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #3
          -----END CERTIFICATE-----
        PEM
      )
    end

    it "must query all #{described_class} with the matching subject organization" do
      certs = subject.with_organization('Test Co.')

      expect(certs.length).to eq(2)

      expect(certs[0].subject).to be_kind_of(Ronin::DB::CertSubject)
      expect(certs[0].subject.organization).to eq('Test Co.')

      expect(certs[1].subject).to be_kind_of(Ronin::DB::CertSubject)
      expect(certs[1].subject.organization).to eq('Test Co.')
    end

    after do
      Ronin::DB::Cert.destroy_all
      Ronin::DB::CertSubjectAltName.destroy_all
      Ronin::DB::CertIssuer.destroy_all
      Ronin::DB::CertSubject.destroy_all
      Ronin::DB::CertName.destroy_all
    end
  end

  describe ".with_organizational_unit" do
    subject { described_class }

    before do
      described_class.create(
        serial:  serial,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'test1.com'),
          organization:        'Test Co.',
          organizational_unit: 'Test Dept',
          locality:            'Test City',
          state:               'NY',
          country:             'US'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #1"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #1"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #1
          -----END CERTIFICATE-----
        PEM
      )

      described_class.create(
        serial:  serial + 1,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'other.com'),
          organization:        'Other Co.',
          organizational_unit: 'Other Dept',
          locality:            'Other City',
          state:               'XX',
          country:             'XX'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #2"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #2"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #2
          -----END CERTIFICATE-----
        PEM
      )

      described_class.create(
        serial:  serial + 2,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'test2.com'),
          organization:        'Test Co.',
          organizational_unit: 'Test Dept',
          locality:            'Test City',
          state:               'NY',
          country:             'US'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #3"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #3"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #3
          -----END CERTIFICATE-----
        PEM
      )
    end

    it "must query all #{described_class} with the matching subject organizational unit" do
      certs = subject.with_organizational_unit('Test Dept')

      expect(certs.length).to eq(2)

      expect(certs[0].subject).to be_kind_of(Ronin::DB::CertSubject)
      expect(certs[0].subject.organizational_unit).to eq('Test Dept')

      expect(certs[1].subject).to be_kind_of(Ronin::DB::CertSubject)
      expect(certs[1].subject.organizational_unit).to eq('Test Dept')
    end

    after do
      Ronin::DB::Cert.destroy_all
      Ronin::DB::CertSubjectAltName.destroy_all
      Ronin::DB::CertIssuer.destroy_all
      Ronin::DB::CertSubject.destroy_all
      Ronin::DB::CertName.destroy_all
    end
  end

  describe ".with_locality" do
    subject { described_class }

    before do
      described_class.create(
        serial:  serial,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'test1.com'),
          organization:        'Test Co.',
          organizational_unit: 'Test Dept',
          locality:            'Test City',
          state:               'NY',
          country:             'US'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #1"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #1"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #1
          -----END CERTIFICATE-----
        PEM
      )

      described_class.create(
        serial:  serial + 1,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'other.com'),
          organization:        'Other Co.',
          organizational_unit: 'Other Dept',
          locality:            'Other City',
          state:               'XX',
          country:             'XX'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #2"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #2"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #2
          -----END CERTIFICATE-----
        PEM
      )

      described_class.create(
        serial:  serial + 2,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'test2.com'),
          organization:        'Test Co.',
          organizational_unit: 'Test Dept',
          locality:            'Test City',
          state:               'NY',
          country:             'US'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #3"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #3"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #3
          -----END CERTIFICATE-----
        PEM
      )
    end

    it "must query all #{described_class} with the matching subject locality" do
      certs = subject.with_locality('Test City')

      expect(certs.length).to eq(2)

      expect(certs[0].subject).to be_kind_of(Ronin::DB::CertSubject)
      expect(certs[0].subject.locality).to eq('Test City')

      expect(certs[1].subject).to be_kind_of(Ronin::DB::CertSubject)
      expect(certs[1].subject.locality).to eq('Test City')
    end

    after do
      Ronin::DB::Cert.destroy_all
      Ronin::DB::CertSubjectAltName.destroy_all
      Ronin::DB::CertIssuer.destroy_all
      Ronin::DB::CertSubject.destroy_all
      Ronin::DB::CertName.destroy_all
    end
  end

  describe ".with_state" do
    subject { described_class }

    before do
      described_class.create(
        serial:  serial,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'test1.com'),
          organization:        'Test Co.',
          organizational_unit: 'Test Dept',
          locality:            'Test City',
          state:               'NY',
          country:             'US'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #1"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #1"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #1
          -----END CERTIFICATE-----
        PEM
      )

      described_class.create(
        serial:  serial + 1,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'other.com'),
          organization:        'Other Co.',
          organizational_unit: 'Other Dept',
          locality:            'Other City',
          state:               'XX',
          country:             'XX'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #2"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #2"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #2
          -----END CERTIFICATE-----
        PEM
      )

      described_class.create(
        serial:  serial + 2,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'test2.com'),
          organization:        'Test Co.',
          organizational_unit: 'Test Dept',
          locality:            'Test City',
          state:               'NY',
          country:             'US'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #3"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #3"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #3
          -----END CERTIFICATE-----
        PEM
      )
    end

    it "must query all #{described_class} with the matching subject state" do
      certs = subject.with_state('NY')

      expect(certs.length).to eq(2)

      expect(certs[0].subject).to be_kind_of(Ronin::DB::CertSubject)
      expect(certs[0].subject.state).to eq('NY')

      expect(certs[1].subject).to be_kind_of(Ronin::DB::CertSubject)
      expect(certs[1].subject.state).to eq('NY')
    end

    after do
      Ronin::DB::Cert.destroy_all
      Ronin::DB::CertSubjectAltName.destroy_all
      Ronin::DB::CertIssuer.destroy_all
      Ronin::DB::CertSubject.destroy_all
      Ronin::DB::CertName.destroy_all
    end
  end

  describe ".with_country" do
    subject { described_class }

    before do
      described_class.create(
        serial:  serial,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'test1.com'),
          organization:        'Test Co.',
          organizational_unit: 'Test Dept',
          locality:            'Test City',
          state:               'NY',
          country:             'US'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #1"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #1"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #1
          -----END CERTIFICATE-----
        PEM
      )

      described_class.create(
        serial:  serial + 1,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'other.com'),
          organization:        'Other Co.',
          organizational_unit: 'Other Dept',
          locality:            'Other City',
          state:               'XX',
          country:             'XX'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #2"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #2"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #2
          -----END CERTIFICATE-----
        PEM
      )

      described_class.create(
        serial:  serial + 2,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'test2.com'),
          organization:        'Test Co.',
          organizational_unit: 'Test Dept',
          locality:            'Test City',
          state:               'NY',
          country:             'US'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Cert #3"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Cert #3"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Cert #3
          -----END CERTIFICATE-----
        PEM
      )
    end

    it "must query all #{described_class} with the matching subject country" do
      certs = subject.with_country('US')

      expect(certs.length).to eq(2)

      expect(certs[0].subject).to be_kind_of(Ronin::DB::CertSubject)
      expect(certs[0].subject.country).to eq('US')

      expect(certs[1].subject).to be_kind_of(Ronin::DB::CertSubject)
      expect(certs[1].subject.country).to eq('US')
    end

    after do
      Ronin::DB::Cert.destroy_all
      Ronin::DB::CertSubjectAltName.destroy_all
      Ronin::DB::CertIssuer.destroy_all
      Ronin::DB::CertSubject.destroy_all
      Ronin::DB::CertName.destroy_all
    end
  end

  describe ".import" do
    subject { described_class.import(cert) }

    it "must set #serial to the hexadecimal version of the certificate's #serial number" do
      expect(subject.serial).to eq(cert.serial.to_s(16))
    end

    it "must set #version to the certificate's #version" do
      expect(subject.version).to eq(cert.version)
    end

    it "must set #not_before to the certificate's #not_before" do
      expect(subject.not_before).to eq(cert.not_before)
    end

    it "must set #not_after to the certificate's #not_after" do
      expect(subject.not_after).to eq(cert.not_after)
    end

    it "must set #issuer to a CertIssuer resource" do
      expect(subject.issuer).to be_kind_of(Ronin::DB::CertIssuer)
    end

    describe "issuer" do
      subject { super().issuer }

      it "must set #common_name" do
        expect(subject.common_name).to eq('Test CA')
      end

      it "must set #email_address" do
        expect(subject.email_address).to eq('admin@test-ca.com')
      end

      it "must set #organization" do
        expect(subject.organization).to eq('Test CA, Inc.')
      end

      it "must set #organizational_unit" do
        expect(subject.organizational_unit).to eq('CA Dept')
      end

      it "must set #locality" do
        expect(subject.locality).to eq('CA City')
      end

      it "must set #state" do
        expect(subject.state).to eq('NY')
      end

      it "must set #country" do
        expect(subject.country).to eq('US')
      end

      context "when the cert is self-signed" do
        let(:cert_file) { 'self_signed_cert.crt' }

        it "must set #issuer to nil" do
          expect(subject).to be(nil)
        end
      end
    end

    it "must set #subject to a CertSubject resource" do
      expect(subject.subject).to be_kind_of(Ronin::DB::CertSubject)
    end

    describe "subject" do
      subject { super().subject }

      it "must set #common_name" do
        expect(subject.common_name).to be_kind_of(Ronin::DB::CertName)
        expect(subject.common_name.name).to eq('test.com')
      end

      it "must set #email_address" do
        expect(subject.email_address).to eq('admin@test.com')
      end

      it "must set #organization" do
        expect(subject.organization).to eq('Test Co.')
      end

      xit "must set #organizational_unit" do
        expect(subject.organizational_unit).to eq('Test Dept')
      end

      it "must set #locality" do
        expect(subject.locality).to eq('Test City')
      end

      it "must set #state" do
        expect(subject.state).to eq('NY')
      end

      it "must set #country" do
        expect(subject.country).to eq('US')
      end
    end

    context "when the certificate has a subjectAltName extension" do
      let(:cert_file) { 'cert_with_subject_alt_names.crt' }

      it "must populate #subject_alt_names" do
        expect(subject.subject_alt_names.length).to eq(2)

        expect(subject.subject_alt_names[0]).to be_kind_of(Ronin::DB::CertSubjectAltName)
        expect(subject.subject_alt_names[0].name).to be_kind_of(Ronin::DB::CertName)
        expect(subject.subject_alt_names[0].name.name).to eq('test2.com')

        expect(subject.subject_alt_names[1]).to be_kind_of(Ronin::DB::CertSubjectAltName)
        expect(subject.subject_alt_names[1].name).to be_kind_of(Ronin::DB::CertName)
        expect(subject.subject_alt_names[1].name.name).to eq('test3.com')
      end
    end

    context "when the certificate uses a RSA public key" do
      let(:cert_file) { 'rsa_cert.crt' }

      it "must set #public_key_algorithm to 'rsa'" do
        expect(subject.public_key_algorithm).to eq('rsa')
      end

      it "must set #public_key_size to the RSA public key's bit size" do
        expect(subject.public_key_size).to eq(4096)
      end
    end

    context "when the certificate uses a DSA public key" do
      let(:cert_file) { 'dsa_cert.crt' }

      it "must set #public_key_algorithm to 'dsa'" do
        expect(subject.public_key_algorithm).to eq('dsa')
      end

      it "must set #public_key_size to the DSA public key's bit size" do
        expect(subject.public_key_size).to eq(1024)
      end
    end

    context "when the certificate uses a DH public key" do
      # TODO: need to generate a X509 certificate with a DH key pair
      let(:cert_file) { 'dh_cert.crt' }

      xit "must set #public_key_algorithm to 'dh'" do
        expect(subject.public_key_algorithm).to eq('dh')
      end

      xit "must set #public_key_size to the DH public key's bit size" do
        expect(subject.public_key_size).to eq(1024)
      end
    end

    context "when the certificate uses a EC public key" do
      let(:cert_file) { 'ec_cert.crt' }

      it "must set #public_key_algorithm to 'ec'" do
        if RUBY_ENGINE == 'jruby'
          skip "JRuby's openssl does not provide OpenSSL::PKey::EC#to_text"
        end

        expect(subject.public_key_algorithm).to eq('ec')
      end

      it "must set #public_key_size to the EC key's bit size" do
        if RUBY_ENGINE == 'jruby'
          skip "JRuby's openssl does not provide OpenSSL::PKey::EC#to_text"
        end

        expect(subject.public_key_size).to eq(256)
      end
    end

    after do
      Ronin::DB::Cert.destroy_all
      Ronin::DB::CertSubjectAltName.destroy_all
      Ronin::DB::CertIssuer.destroy_all
      Ronin::DB::CertSubject.destroy_all
      Ronin::DB::CertName.destroy_all
    end
  end

  describe ".lookup" do
    subject { described_class }

    before do
      described_class.create(
        serial:  serial + 1,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'other1.com'),
          organization:        'Other Co.',
          organizational_unit: 'Other Dept',
          locality:            'Other City',
          state:               'XX',
          country:             'XX'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Other Cert #1"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Other Cert #1"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Other Cert #1
          -----END CERTIFICATE-----
        PEM
      )

      subject.import(cert)

      described_class.create(
        serial:  serial + 2,
        version: version,

        not_before: Time.now - one_year,
        not_after:  Time.now + one_year,

        subject: Ronin::DB::CertSubject.create(
          common_name:         Ronin::DB::CertName.create(name: 'other2.com'),
          organization:        'Other Co.',
          organizational_unit: 'Other Dept',
          locality:            'Other City',
          state:               'XX',
          country:             'XX'
        ),

        public_key_algorithm: public_key_algorithm,
        public_key_size:      public_key_size,

        signing_algorithm: signing_algorithm,

        sha1_fingerprint:   Digest::SHA1.hexdigest("Other Cert #2"),
        sha256_fingerprint: Digest::SHA256.hexdigest("Other Cert #2"),

        pem: <<~PEM
          -----BEGIN CERTIFICATE-----
          Other Cert #2
          -----END CERTIFICATE-----
        PEM
      )
    end

    it "must query #{described_class} for the cert with the same SHA256 fingerprint of the DER version of the certificate" do
      matching_cert = subject.lookup(cert)

      expect(matching_cert).to be_kind_of(described_class)
      expect(matching_cert.pem).to eq(cert.to_pem)
    end

    after do
      Ronin::DB::Cert.destroy_all
      Ronin::DB::CertSubjectAltName.destroy_all
      Ronin::DB::CertIssuer.destroy_all
      Ronin::DB::CertSubject.destroy_all
      Ronin::DB::CertName.destroy_all
    end
  end

  subject do
    described_class.new(
      serial:  serial,
      version: version,

      not_before: not_before,
      not_after:  not_after,

      issuer: Ronin::DB::CertIssuer.new(
        common_name:         'Test CA',
        email_address:       'admin@test-ca.com',
        organization:        'Test CA, Inc.',
        organizational_unit: 'CA Dept',
        locality:            'CA City',
        state:               'NY',
        country:             'US'
      ),

      subject: Ronin::DB::CertSubject.new(
        common_name:         Ronin::DB::CertName.new(name: 'test.com'),
        email_address:       'admin@test.com',
        organization:        'Test Co.',
        organizational_unit: 'Test Dept',
        locality:            'Test City',
        state:               'NY',
        country:             'US'
      ),

      subject_alt_names: [
        Ronin::DB::CertSubjectAltName.new(
          name: Ronin::DB::CertName.new(name: 'test2.com')
        ),

        Ronin::DB::CertSubjectAltName.new(
          name: Ronin::DB::CertName.new(name: 'test3.com')
        )
      ],

      public_key_algorithm: public_key_algorithm,
      public_key_size:      public_key_size,

      signing_algorithm: signing_algorithm,

      sha1_fingerprint:   sha1_fingerprint,
      sha256_fingerprint: sha256_fingerprint,

      pem: pem
    )
  end

  describe "#common_name" do
    it "must return #subject.common_name" do
      expect(subject.common_name).to eq(subject.subject.common_name)
    end
  end

  describe "#organization" do
    it "must return #subject.organization" do
      expect(subject.organization).to eq(subject.subject.organization)
    end
  end

  describe "#organizational_unit" do
    it "must return #subject.organizational_unit" do
      expect(subject.organizational_unit).to eq(subject.subject.organizational_unit)
    end
  end

  describe "#state" do
    it "must return #subject.state" do
      expect(subject.state).to eq(subject.subject.state)
    end
  end

  describe "#country" do
    it "must return #subject.country" do
      expect(subject.country).to eq(subject.subject.country)
    end
  end

  describe "#to_pem" do
    it "must return #pem" do
      expect(subject.to_pem).to eq(subject.pem)
    end
  end
end
