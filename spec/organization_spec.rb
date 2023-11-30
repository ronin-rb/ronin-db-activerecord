require 'spec_helper'
require 'ronin/db/organization'

describe Ronin::DB::Organization do
  it "must use the 'ronin_organizations' table" do
    expect(described_class.table_name).to eq('ronin_organizations')
  end

  let(:name) { 'ACME, Corp.' }

  describe "validations" do
    it "must require a unique #name" do
      described_class.create(name: name)

      organization2 = described_class.new(name: name)

      expect(organization2).to_not be_valid
      expect(organization2.errors[:name]).to eq(['has already been taken'])
    end

    it "must allow duplicate #name values if #parent is different" do
      parent_org1 = described_class.create(name: 'Parent Org1')
      parent_org2 = described_class.create(name: 'Parent Org2')

      subsidiary1 = described_class.new(name: 'Subsidary', parent: parent_org1)
      subsidiary2 = described_class.new(name: 'Subsidary', parent: parent_org2)

      expect(subsidiary1).to be_valid
      expect(subsidiary2).to be_valid
    end

    after { described_class.destroy_all }
  end

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
