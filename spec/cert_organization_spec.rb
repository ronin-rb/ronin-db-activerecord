require 'spec_helper'
require 'ronin/db/cert_organization'

require 'openssl'

describe Ronin::DB::CertOrganization do
  describe ".parse" do
    let(:common_name)         { 'example.com' }
    let(:email_address)       { 'admin@example.com' }
    let(:organization)        { 'Example Org' }
    let(:organizational_unit) { 'Example Dept' }
    let(:locality)            { '1234 Example St' }
    let(:state)               { 'NY' }
    let(:country)             { 'US' }

    context "when given a OpenSSL::X509::Name object" do
      context "when the 'CN' attribute is set" do
        let(:name) { OpenSSL::X509::Name.new }

        before { name.add_entry('CN',common_name) }

        subject { described_class.parse(name) }

        it "must return a Hash containing the :common_name key" do
          expect(subject).to eq({common_name: common_name})
        end
      end

      context "when the 'emailAddress' attribute is set" do
        let(:name) { OpenSSL::X509::Name.new }

        before { name.add_entry('emailAddress',email_address) }

        subject { described_class.parse(name) }

        it "must return a Hash containing the :email_address key" do
          expect(subject).to eq({email_address: email_address})
        end
      end

      context "when the 'O' attribute is set" do
        let(:name) { OpenSSL::X509::Name.new }

        before { name.add_entry('O',organization) }

        subject { described_class.parse(name) }

        it "must return a Hash containing the :organization key" do
          expect(subject).to eq({organization: organization})
        end
      end

      context "when the 'OU' attribute is set" do
        let(:name) { OpenSSL::X509::Name.new }

        before { name.add_entry('OU',organizational_unit) }

        subject { described_class.parse(name) }

        it "must return a Hash containing the :organizational_unit key" do
          expect(subject).to eq({organizational_unit: organizational_unit})
        end
      end

      context "when the 'L' attribute is set" do
        let(:name) { OpenSSL::X509::Name.new }

        before { name.add_entry('L',locality) }

        subject { described_class.parse(name) }

        it "must return a Hash containing the :locality key" do
          expect(subject).to eq({locality: locality})
        end
      end

      context "when the 'ST' attribute is set" do
        let(:name) { OpenSSL::X509::Name.new }

        before { name.add_entry('ST',state) }

        subject { described_class.parse(name) }

        it "must return a Hash containing the :state key" do
          expect(subject).to eq({state: state})
        end
      end

      context "when the 'C' attribute is set" do
        let(:name) { OpenSSL::X509::Name.new }

        before { name.add_entry('C',country) }

        subject { described_class.parse(name) }

        it "must return a Hash containing the :country key" do
          expect(subject).to eq({country: country})
        end
      end
    end

    context "when given a String object" do
      let(:name) { OpenSSL::X509::Name.new }

      before do
        name.add_entry('CN',common_name)
        name.add_entry('emailAddress',email_address)
        name.add_entry('O',organization)
        name.add_entry('OU',organizational_unit)
        name.add_entry('L',locality)
        name.add_entry('ST',state)
        name.add_entry('C',country)
      end

      subject { described_class.parse(name.to_s) }

      it "must parse the String and return a Hash of attributes" do
        expect(subject).to eq(
          {
            common_name:         common_name,
            email_address:       email_address,
            organization:        organization,
            organizational_unit: organizational_unit,
            locality:            locality,
            state:               state,
            country:             country
          }
        )
      end
    end

    context "when given another type of Object" do
      let(:object) { Object.new }

      it do
        expect {
          described_class.parse(object)
        }.to raise_error(ArgumentError,"value must be either an OpenSSL::X509::Name or a String: #{object.inspect}")
      end
    end
  end
end
