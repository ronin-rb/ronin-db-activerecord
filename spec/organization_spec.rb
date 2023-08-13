require 'spec_helper'
require 'ronin/db/organization'

describe Ronin::DB::Organization do
  it "must use the 'ronin_organizations' table" do
    expect(described_class.table_name).to eq('ronin_organizations')
  end

  let(:name) { 'ACME, Corp.' }

  describe ".lookup" do
    before do
      described_class.create(name: 'Foo, Inc.')
      described_class.create(name: name)
      described_class.create(name: 'Bar, Inc.')
    end

    it "must query the #{described_class} with the matching name" do
      organization = described_class.lookup(name)

      expect(organization).to be_kind_of(described_class)
      expect(organization.name).to eq(name)
    end

    after { described_class.destroy_all }
  end

  describe ".import" do
    subject { described_class.import(name) }

    it "must import the #{described_class} and set #name" do
      expect(subject).to be_kind_of(described_class)
      expect(subject.id).to_not be(nil)
      expect(subject.name).to eq(name)
    end

    after { described_class.destroy_all }
  end
end
