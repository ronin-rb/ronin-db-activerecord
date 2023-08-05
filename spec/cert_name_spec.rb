require 'spec_helper'
require 'ronin/db/cert_name'

describe Ronin::DB::CertName do
  it "must use the 'ronin_cert_names' table" do
    expect(described_class.table_name).to eq('ronin_cert_names')
  end

  let(:name) { 'example.com' }

  describe "validations" do
    describe "name" do
      it "require an host name" do
        host_name = described_class.new
        expect(host_name).to_not be_valid

        host_name = described_class.new(name: name)
        expect(host_name).to be_valid
      end

      it "must require a unique name" do
        described_class.create(name: name)

        host_name = described_class.new(name: name)
        expect(host_name).to_not be_valid

        described_class.destroy_all
      end
    end
  end

  describe ".lookup" do
    before do
      described_class.create(name: 'other.host1.com')
      described_class.create(name: name)
      described_class.create(name: 'other.host2.com')
    end

    it "must query the #{described_class} with the matching name" do
      host_name = described_class.lookup(name)

      expect(host_name).to be_kind_of(described_class)
      expect(host_name.name).to eq(name)
    end

    after { described_class.destroy_all }
  end

  describe ".import" do
    let(:name) { 'example.com' }

    subject { described_class.import(name) }

    it "must import the host name and return a new #{described_class} record" do
      expect(subject).to be_kind_of(described_class)
      expect(subject.id).to_not be(nil)
      expect(subject.name).to eq(name)
    end

    after { described_class.destroy_all }
  end

  subject { described_class.new(name: name) }

  describe "#to_s" do
    it "must return the #name" do
      expect(subject.to_s).to eq(name)
    end
  end
end
