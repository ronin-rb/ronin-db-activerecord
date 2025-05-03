require 'spec_helper'
require 'ronin/db/organization'

describe Ronin::DB::Organization do
  it "must use the 'ronin_organizations' table" do
    expect(described_class.table_name).to eq('ronin_organizations')
  end

  let(:name) { 'ACME, Corp.' }

  describe "validations" do
    describe "name" do
      it "must require a unique #name" do
        described_class.create(name: name)

        organization2 = described_class.new(name: name)

        expect(organization2).to_not be_valid
        expect(organization2.errors[:name]).to eq(['has already been taken'])
      end

      it "must allow duplicate #name values if #parent is different" do
        parent_org1 = described_class.create(name: 'Parent Org1')
        parent_org2 = described_class.create(name: 'Parent Org2')

        subsidiary_org1 = described_class.new(
          name:   'Subsidary',
          parent: parent_org1
        )
        subsidiary_org2 = described_class.new(
          name:   'Subsidary',
          parent: parent_org2
        )

        expect(subsidiary_org1).to be_valid
        expect(subsidiary_org2).to be_valid
      end
    end

    describe "type" do
      it "must accept nil" do
        org = described_class.new(name: 'Type-less Org')

        expect(org).to be_valid
      end

      it "must accept 'company'" do
        org = described_class.new(name: 'Company Org', type: 'company')

        expect(org).to be_valid
      end

      it "must accept 'government'" do
        org = described_class.new(name: 'Government Org', type: 'government')

        expect(org).to be_valid
      end

      it "must accept 'military'" do
        org = described_class.new(name: 'Military Org', type: 'military')

        expect(org).to be_valid
      end

      it "must not accept other values" do
        org = described_class.new(name: 'Other Org', type: 'other')

        expect(org).to_not be_valid
        expect(org.errors[:type]).to eq(['is not included in the list'])
      end
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

  describe "#is_company?" do
    context "when #type is 'company'" do
      subject do
        described_class.new(name: 'Company Org', type: 'company')
      end

      it "must return true" do
        expect(subject.is_company?).to be(true)
      end
    end

    context "when #type is not 'company'" do
      subject do
        described_class.new(name: 'Other Org')
      end

      it "must return false" do
        expect(subject.is_company?).to be(false)
      end
    end
  end

  describe "#is_government?" do
    context "when #type is 'government'" do
      subject do
        described_class.new(name: 'Government Org', type: 'government')
      end

      it "must return true" do
        expect(subject.is_government?).to be(true)
      end
    end

    context "when #type is not 'government'" do
      subject do
        described_class.new(name: 'Other Org')
      end

      it "must return false" do
        expect(subject.is_government?).to be(false)
      end
    end
  end

  describe "#is_military?" do
    context "when #type is 'military'" do
      subject do
        described_class.new(name: 'Military Org', type: 'military')
      end

      it "must return true" do
        expect(subject.is_military?).to be(true)
      end
    end

    context "when #type is not 'military'" do
      subject do
        described_class.new(name: 'Other Org')
      end

      it "must return false" do
        expect(subject.is_military?).to be(false)
      end
    end
  end
end
