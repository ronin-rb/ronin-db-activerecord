require 'spec_helper'
require 'ronin/db/personal_connection'

describe Ronin::DB::PersonalConnection do
  it "must use the 'ronin_personal_connections' table" do
    expect(described_class.table_name).to eq('ronin_personal_connections')
  end

  let(:person1) do
    Ronin::DB::Person.new(
      full_name:  'Person One',
      first_name: 'Person',
      last_name:  'One'
    )
  end

  let(:person2) do
    Ronin::DB::Person.new(
      full_name:  'Person Two',
      first_name: 'Person',
      last_name:  'Two'
    )
  end

  let(:type) { nil }

  subject do
    described_class.new(
      type:         type,
      person:       person1,
      other_person: person2
    )
  end

  describe "validations" do
    describe "type" do
      [
        :friend,
        :collegue,
        :coworker,

        :parent,
        :mother,
        :father,
        :aunt,
        :uncle,
        :brother,
        :sister,
        :cousin,
        :nephew,
        :niece,

        :stepmother,
        :stepfather,
        :stepchild,
        :stepbrother,
        :stepsister,

        :in_law,
        :father_in_law,
        :mother_in_law,

        :partner,
        :boyfriend,
        :girlfriend,
        :husband,
        :wife,

        :ex,
        :ex_husband,
        :ex_wife
      ].each do |valid_type|
        it "must accept #{valid_type.inspect}" do
          connection = described_class.new(
            type:         valid_type,
            person:       person1,
            other_person: person2
          )

          expect(connection).to be_valid
        end
      end

      it "must not accept other values" do
        expect {
          described_class.new(
            type:         :other,
            person:       person1,
            other_person: person2
          )
        }.to raise_error(ArgumentError,"'other' is not a valid type")
      end
    end
  end
end
