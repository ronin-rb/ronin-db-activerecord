require 'spec_helper'
require 'ronin/db/cert_subject_alt_name'

describe Ronin::DB::CertSubjectAltName do
  describe ".parse" do
    let(:domain1) { 'example1.com' }
    let(:domain2) { 'example2.com' }
    let(:ip)      { '192.168.1.1' }
    let(:string)  { "DNS:#{domain1}, DNS:#{domain2}, IP:#{ip}" }

    subject { described_class.parse(string) }

    it "must return an Array of parsed subjectAltNames" do
      expect(subject).to eq([domain1, domain2, ip])
    end
  end

  let(:name)      { 'example.com' }
  let(:cert_name) { Ronin::DB::CertName.new(name: name) }

  subject { described_class.new(name: cert_name) }

  describe "#to_s" do
    it "must return the CertName's #name" do
      expect(subject.to_s).to eq(name)
    end
  end
end
