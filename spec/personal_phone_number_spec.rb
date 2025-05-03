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
        personal_phone_number = described_class.new(
          type:         :other,
          person:       person,
          phone_number: phone_number
        )

        expect(personal_phone_number).to_not be_valid
        expect(personal_phone_number.errors[:type]).to eq(
          ['is not included in the list']
        )
      end
    end
  end

  describe "#home?" do
    context "when #type is :home" do
      let(:type) { :home }

      it "must return true" do
        expect(subject.home?).to be(true)
      end
    end

    context "when #type is not :home" do
      it "must return false" do
        expect(subject.home?).to be(false)
      end
    end
  end

  describe "#cell?" do
    context "when #type is :cell" do
      let(:type) { :cell }

      it "must return true" do
        expect(subject.cell?).to be(true)
      end
    end

    context "when #type is not :cell" do
      it "must return false" do
        expect(subject.cell?).to be(false)
      end
    end
  end

  describe "#fax?" do
    context "when #type is :fax" do
      let(:type) { :fax }

      it "must return true" do
        expect(subject.fax?).to be(true)
      end
    end

    context "when #type is not :fax" do
      it "must return false" do
        expect(subject.fax?).to be(false)
      end
    end
  end

  describe "#voip?" do
    context "when #type is :voip" do
      let(:type) { :voip }

      it "must return true" do
        expect(subject.voip?).to be(true)
      end
    end

    context "when #type is not :voip" do
      it "must return false" do
        expect(subject.voip?).to be(false)
      end
    end
  end
end
