# frozen_string_literal: true
#
# ronin-db-activerecord - ActiveRecord backend for the Ronin Database.
#
# Copyright (c) 2022-2023 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# ronin-db-activerecord is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-db-activerecord is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with ronin-db-activerecord.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/db/model'
require 'ronin/db/model/importable'

module Ronin
  module DB
    #
    # Represents a SSL/TLS certificate.
    #
    # @since 0.2.0
    #
    class Cert < ActiveRecord::Base

      include Model
      include Model::Importable

      # @!attribute [rw] id
      #   The primary ID of the certificate.
      #
      #   @return [Integer]
      attribute :id, :integer

      # @!attribute [rw] serial
      #   The certificate's serial number.
      #
      #   @return [String]
      attribute :serial, :string
      validates :serial, presence:   true,
                         uniqueness: true

      # @!attribute [rw] version
      #   The certificate's version number.
      #
      #   @return [Integer]
      attribute :version, :integer
      validates :version, presence: true

      # @!attribute [rw] not_before
      #   When the certificate starts being valid.
      #
      #   @return [Time]
      attribute :not_before, :datetime
      validates :not_before, presence: true

      # @!attribute [rw] not_after
      #   When the certificate expires.
      #
      #   @return [Time]
      attribute :not_after, :datetime
      validates :not_after, presence: true

      # @!attribute [rw] issuer
      #   The certificate issuer information.
      #
      #   @return [CertIssuer, nil]
      #
      #   @note
      #     When the certificate is self-signed, {#issuer} will not be set.
      belongs_to :issuer, class_name: 'CertIssuer',
                          optional:   true

      # @!attribute [rw] subject
      #   The certificate subject information.
      #
      #   @return [CertSubject]
      belongs_to :subject, class_name: 'CertSubject',
                           required:   true

      # @!attribute [rw] public_key_algorithm
      #   The public key algorithm.
      #
      #   @return [:rsa, :dsa, :dh, :ec]
      enum :public_key_algorithm, {rsa: 'rsa', dsa: 'dsa', dh: 'dh', ec: 'ec'}
      validates :public_key_algorithm, presence: true

      # @!attribute [rw] public_key_size
      #   The public key size in bits.
      #
      # @return [Integer]
      attribute :public_key_size, :integer
      validates :public_key_size, presence: true

      # @!attribute [rw] signing_algorithm
      #   The algorithm used to sign the certificate.
      #
      #   @return [String]
      attribute :signing_algorithm, :string
      validates :signing_algorithm, presence: true

      # @!attribute [rw] sha1_fingerprint
      #   The SHA1 fingerprint of the certificate.
      #
      #   @return [String]
      attribute :sha1_fingerprint

      # @!attribute [rw] sha256_fingerprint
      #   The SHA256 fingerprint of the certificate.
      #
      #   @return [String]
      attribute :sha256_fingerprint

      # @!attribute [rw] pem
      #   The PEM encoded version of the certificate.
      #
      #   @return [String]
      attribute :pem, :text
      validates :pem, presence: true

      # @!attribute [rw] created_at
      #   When the certificate was created.
      #
      #   @return [Time]
      attribute :created_at, :datetime

      # @!attribute [rw] subject_alt_names
      #   The `subjectAltName`s of the certificate.
      #
      #   @return [Array<CertSubjectAltName>]
      has_many :subject_alt_names, class_name: 'CertSubjectAltName',
                                   dependent:  :destroy

      # @!attribute [rw] open_ports
      #   The open ports that use this certificate.
      #
      #   @return [Array<OpenPort>]
      has_many :open_ports, dependent: :nullify

      # @!attribute [rw] ip_addresses
      #   The IP addresses that use this certificate.
      #
      #   @return [Array<IPAddress>]
      has_many :ip_addresses, through: :open_ports

      # @!attribute [rw] notes
      #   The associated notes.
      #
      #   @return [Array<Note>]
      #
      #   @since 0.2.0
      has_many :notes

      #
      # Queries all active certificates.
      #
      # @return [Array<Cert>]
      #
      def self.active
        now = DateTime.now

        where(not_before: ..now, not_after: now...)
      end

      #
      # Queries all expired certificates.
      #
      # @return [Array<Cert>]
      #
      def self.expired
        where(not_after: ...Time.now)
      end

      #
      # Queries all certificates with the issuer common name (`CN`).
      #
      # @param [String] name
      #   The issuer common name to search for.
      #
      # @return [Array<Cert>]
      #
      def self.with_issuer_common_name(name)
        joins(:issuer).where(issuer: {common_name: name})
      end

      #
      # Queries all certificates with the issuer common name (`O`).
      #
      # @param [String] name
      #   The issuer organization to search for.
      #
      # @return [Array<Cert>]
      #
      def self.with_issuer_organization(name)
        joins(:issuer).where(issuer: {organization: name})
      end

      #
      # Queries all certificates with the issuer common name (`OU`).
      #
      # @param [String] unit
      #   The issuer organizational unit name to search for.
      #
      # @return [Array<Cert>]
      #
      def self.with_issuer_organizational_unit(unit)
        joins(:issuer).where(issuer: {organizational_unit: unit})
      end

      #
      # Queries all certificates with the issuer common name (`L`).
      #
      # @param [String] locality
      #   The issuer locality to search for.
      #
      # @return [Array<Cert>]
      #
      def self.with_issuer_locality(locality)
        joins(:issuer).where(issuer: {locality: locality})
      end

      #
      # Queries all certificates with the issuer common name (`ST`).
      #
      # @param [String] state
      #   The issuer state name to search for.
      #
      # @return [Array<Cert>]
      #
      def self.with_issuer_state(state)
        joins(:issuer).where(issuer: {state: state})
      end

      #
      # Queries all certificates with the issuer common name (`C`).
      #
      # @param [String] country
      #   The issuer's two-letter country code to search for.
      #
      # @return [Array<Cert>]
      #
      def self.with_issuer_country(country)
        joins(:issuer).where(issuer: {country: country})
      end

      #
      # Queries all certificates with the subject state (`O`).
      #
      # @param [String] name
      #   The organization name to search for.
      #
      # @return [Array<Cert>]
      #
      def self.with_organization(name)
        joins(:subject).where(subject: {organization: name})
      end

      #
      # Queries all certificates with the subject state (`OU`).
      #
      # @param [String] unit
      #   The organizational unit name to search for.
      #
      # @return [Array<Cert>]
      #
      def self.with_organizational_unit(unit)
        joins(:subject).where(subject: {organizational_unit: unit})
      end

      #
      # Queries all certificates with the subject state (`L`).
      #
      # @param [String] locality
      #   The locality to search for.
      #
      # @return [Array<Cert>]
      #
      def self.with_locality(locality)
        joins(:subject).where(subject: {locality: locality})
      end

      #
      # Queries all certificates with the subject state (`ST`).
      #
      # @param [String] state
      #   The state name to search for.
      #
      # @return [Array<Cert>]
      #
      def self.with_state(state)
        joins(:subject).where(subject: {state: state})
      end

      #
      # Queries all certificates with the subject country (`C`).
      #
      # @param [String] country
      #   The two-letter country code to search for.
      #
      # @return [Array<Cert>]
      #
      def self.with_country(country)
        joins(:subject).where(subject: {country: country})
      end

      #
      # Queries all certificates with the common name (`CN`).
      #
      # @param [String] name
      #   The common name to search for.
      #
      # @return [Array<Cert>]
      #
      def self.with_common_name(name)
        joins(subject: [:common_name]).where(
          subject: {
            common_name: {
              name: name
            }
          }
        )
      end

      #
      # Queries all certificates with the `subjectAltName` value.
      #
      # @param [String] name
      #   The host name or IP address to query.
      #
      # @return [Array<Cert>]
      #
      def self.with_subject_alt_name(name)
        joins(subject_alt_names: [:name]).where(subject_alt_names: {name: {name: name}})
      end

      #
      # Looks up the certificate.
      #
      # @param [OpenSSL::X509::Certificate] cert
      #   The X509 certificate object or PEM string.
      #
      # @return [Cert, nil]
      #   The matching certificate.
      #
      def self.lookup(cert)
        find_by(sha256_fingerprint: Digest::SHA256.hexdigest(cert.to_der))
      end

      #
      # Imports an SSL/TLS X509 certificate into the database.
      #
      # @param [OpenSSL::X509::Certificate] cert
      #   The certificate object to import.
      #
      # @return [Cert]
      #   The imported certificate.
      #
      def self.import(cert)
        case (public_key = cert.public_key)
        when OpenSSL::PKey::RSA
          public_key_algorithm = :rsa
          public_key_size      = public_key.n.num_bits
        when OpenSSL::PKey::DSA
          public_key_algorithm = :dsa
          public_key_size      = public_key.p.num_bits
        when OpenSSL::PKey::DH
          public_key_algorithm = :dh
          public_key_size      = public_key.p.num_bits
        when OpenSSL::PKey::EC
          public_key_algorithm = :ec

          public_key_text = public_key.to_text
          public_key_size = if (match = public_key_text.match(/\((\d+) bit\)/))
                              match[1].to_i
                            end
        else
          raise(NotImplementedError,"unsupported public key type: #{public_key.inspect}")
        end

        der = cert.to_der

        create(
          serial:  cert.serial.to_s(16),
          version: cert.version,

          not_before: cert.not_before,
          not_after:  cert.not_after,

          # NOTE: set #issuer to nil if the cert is self-signed
          issuer: unless cert.issuer == cert.subject
                    CertIssuer.import(cert.issuer)
                  end,

          subject: CertSubject.import(cert.subject),

          public_key_algorithm: public_key_algorithm,
          public_key_size:      public_key_size,

          signing_algorithm: cert.signature_algorithm,

          sha1_fingerprint:   Digest::SHA1.hexdigest(der),
          sha256_fingerprint: Digest::SHA256.hexdigest(der),

          pem: cert.to_pem
        ) do |new_cert|
          if (subject_alt_name = cert.find_extension('subjectAltName'))
            CertSubjectAltName.parse(subject_alt_name.value).each do |name|
              new_cert.subject_alt_names.new(
                name: CertName.find_or_import(name)
              )
            end
          end
        end
      end

      #
      # The subject's common name (`CN`).
      #
      # @return [String]
      #
      def common_name
        subject.common_name
      end

      #
      # The subject's organization (`O`).
      #
      # @return [String]
      #
      def organization
        subject.organization
      end

      #
      # The subject's organizational unit (`OU`).
      #
      # @return [String]
      #
      def organizational_unit
        subject.organizational_unit
      end

      #
      # The subject's locality (`L`).
      #
      # @return [String]
      #
      def locality
        subject.locality
      end

      #
      # The subject's state (`ST`).
      #
      # @return [String]
      #
      def state
        subject.state
      end

      #
      # The subject's country (`C`).
      #
      # @return [String]
      #
      def country
        subject.country
      end

      #
      # Converts the certificate back into PEM format.
      #
      # @return [String]
      #
      def to_pem
        pem
      end

      alias to_s to_pem

    end
  end
end

require 'ronin/db/cert_issuer'
require 'ronin/db/cert_subject'
require 'ronin/db/cert_subject_alt_name'
require 'ronin/db/open_port'
require 'ronin/db/note'
