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

  subject do
    described_class.new(
      organization: organization,
      person:       person
    )
  end

  describe "#to_s" do
    it "must return the #person's full name" do
      expect(subject.to_s).to eq(person.to_s)
    end
  end
end
