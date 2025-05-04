require 'spec_helper'
require 'ronin/db/personal_phone_number'

describe Ronin::DB::PersonalPhoneNumber do
  it "must use the 'ronin_personal_phone_numbers' table" do
    expect(described_class.table_name).to eq('ronin_personal_phone_numbers')
  end

  let(:type) { nil }

  let(:first_name) { 'John' }
  let(:last_name)  { 'Smith' }
  let(:full_name)  { "#{first_name} #{last_name}" }
  let(:person) do
    Ronin::DB::Person.new(
      first_name: first_name,
      last_name:  last_name,
      full_name:  full_name
    )
  end

  let(:country_code) { '1' }
  let(:area_code)    { '555' }
  let(:prefix)       { '555' }
  let(:line_number)  { '8100' }
  let(:number)       { "#{country_code}-#{area_code}-#{prefix}-#{line_number}" }
  let(:phone_number) do
    Ronin::DB::PhoneNumber.new(
      country_code: country_code,
      area_code:    area_code,
      prefix:       prefix,
      line_number:  line_number
    )
  end

  subject do
    described_class.new(
      type:         type,
      person:       person,
      phone_number: phone_number
    )
  end

  describe "validations" do
    describe "type" do
      [
        nil,
        :home,
        :cell,
        :fax,
        :voip
      ].each do |valid_type|
        it "must accept #{valid_type.inspect}" do
          personal_phone_number = described_class.new(
            type:         valid_type,
            person:       person,
            phone_number: phone_number
          )

          expect(personal_phone_number).to be_valid
        end
      end

      it "must not accept other values" do
        expect {
          described_class.new(
            type:         :other,
            person:       person,
            phone_number: phone_number
          )
        }.to raise_error(ArgumentError,"'other' is not a valid type")
      end
    end
  end
end
