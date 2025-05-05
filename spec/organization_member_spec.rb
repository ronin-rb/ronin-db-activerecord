require 'spec_helper'
require 'ronin/db/organization_member'

describe Ronin::DB::OrganizationMember do
  it "must use the 'ronin_organization_members' table" do
    expect(described_class.table_name).to eq('ronin_organization_members')
  end

  let(:first_name) { 'John' }
  let(:last_name)  { 'Smith' }
  let(:full_name)  { "#{first_name} #{last_name}" }

  let(:person) do
    Ronin::DB::Person.new(
      full_name:  full_name,
      first_name: first_name,
      last_name:  last_name
    )
  end

  let(:organization_name) { 'ACME, Corp.' }
  let(:organization) { Ronin::DB::Organization.new(name: organization_name) }

  let(:type) { nil }

  subject do
    described_class.new(
      type:         type,
      organization: organization,
      person:       person
    )
  end

  describe "validations" do
    describe "type" do
      [
        nil,
        :advisor,
        :volunteer,
        :employee,
        :contractor,
        :intern,
        :board_member
      ].each do |valid_type|
        it "must accept #{valid_type.inspect}" do
          member = described_class.new(
            type:         valid_type,
            organization: organization,
            person:       person
          )

          expect(member).to be_valid
        end
      end

      it "must not accept other values" do
        expect {
          described_class.new(
            type:         :other,
            organization: organization,
            person:       person
          )
        }.to raise_error(ArgumentError,"'other' is not a valid type")
      end
    end
  end

  describe "#advisor?" do
    context "when #type is :advisor" do
      let(:type) { :advisor }

      it "must return true" do
        expect(subject.advisor?).to be(true)
      end
    end

    context "when #type is not :advisor" do
      it "must return false" do
        expect(subject.advisor?).to be(false)
      end
    end
  end

  describe "#volunteer?" do
    context "when #type is :volunteer" do
      let(:type) { :volunteer }

      it "must return true" do
        expect(subject.volunteer?).to be(true)
      end
    end

    context "when #type is not :volunteer" do
      it "must return false" do
        expect(subject.volunteer?).to be(false)
      end
    end
  end

  describe "#employee?" do
    context "when #type is :employee" do
      let(:type) { :employee }

      it "must return true" do
        expect(subject.employee?).to be(true)
      end
    end

    context "when #type is not :employee" do
      it "must return false" do
        expect(subject.employee?).to be(false)
      end
    end
  end

  describe "#contractor?" do
    context "when #type is :contractor" do
      let(:type) { :contractor }

      it "must return true" do
        expect(subject.contractor?).to be(true)
      end
    end

    context "when #type is not :contractor" do
      it "must return false" do
        expect(subject.contractor?).to be(false)
      end
    end
  end

  describe "#intern?" do
    context "when #type is :intern" do
      let(:type) { :intern }

      it "must return true" do
        expect(subject.intern?).to be(true)
      end
    end

    context "when #type is not :intern" do
      it "must return false" do
        expect(subject.intern?).to be(false)
      end
    end
  end

  describe "#board_member?" do
    context "when #type is :board_member" do
      let(:type) { :board_member }

      it "must return true" do
        expect(subject.board_member?).to be(true)
      end
    end

    context "when #type is not :board_member" do
      it "must return false" do
        expect(subject.board_member?).to be(false)
      end
    end
  end

  describe "#to_s" do
    it "must return the #person's full name" do
      expect(subject.to_s).to eq(person.to_s)
    end
  end
end
