require 'spec_helper'
require 'ronin/db/phone_number'

describe Ronin::DB::PhoneNumber do
  it "must use the 'ronin_phone_numbers' table" do
    expect(described_class.table_name).to eq('ronin_phone_numbers')
  end

  let(:country_code) { '1' }
  let(:area_code)    { '555' }
  let(:prefix)       { '555' }
  let(:line_number)  { '8100' }
  let(:number)       { "#{country_code}-#{area_code}-#{prefix}-#{line_number}" }

  describe "validations" do
    it "must require a #number" do
      phone_number = described_class.new(
        country_code: country_code,
        area_code:    area_code,
        prefix:       prefix,
        line_number:  line_number
      )

      expect(phone_number).to_not be_valid
      expect(phone_number.errors[:number]).to include("can't be blank")
    end

    it "must require a unique #number" do
      described_class.create(
        number:       number,
        country_code: country_code,
        area_code:    area_code,
        prefix:       prefix,
        line_number:  line_number
      )

      phone_number = described_class.new(
        number:       number,
        country_code: country_code,
        area_code:    area_code,
        prefix:       prefix,
        line_number:  line_number
      )

      expect(phone_number).to_not be_valid
      expect(phone_number.errors[:number]).to eq(['has already been taken'])
    end

    describe "number" do
      it "must accept '+N-NNN-NNN-NNNN'" do
        phone_number = described_class.new(
          number:      "+#{country_code}-#{area_code}-#{prefix}-#{line_number}",
          country_code: country_code,
          area_code:    area_code,
          prefix:       prefix,
          line_number:  line_number
        )

        expect(phone_number).to be_valid
      end

      it "must accept '+NN-NNN-NNN-NNNN'" do
        country_code = '01'

        phone_number = described_class.new(
          number:      "+#{country_code}-#{area_code}-#{prefix}-#{line_number}",
          country_code: country_code,
          area_code:    area_code,
          prefix:       prefix,
          line_number:  line_number
        )

        expect(phone_number).to be_valid
      end

      it "must accept 'N-NNN-NNN-NNNN'" do
        phone_number = described_class.new(
          number:      "#{country_code}-#{area_code}-#{prefix}-#{line_number}",
          country_code: country_code,
          area_code:    area_code,
          prefix:       prefix,
          line_number:  line_number
        )

        expect(phone_number).to be_valid
      end

      it "must accept 'NN-NNN-NNN-NNNN'" do
        country_code = '01'

        phone_number = described_class.new(
          number:      "#{country_code}-#{area_code}-#{prefix}-#{line_number}",
          country_code: country_code,
          area_code:    area_code,
          prefix:       prefix,
          line_number:  line_number
        )

        expect(phone_number).to be_valid
      end

      it "must accept 'NNN-NNN-NNNN'" do
        phone_number = described_class.new(
          number:      "#{area_code}-#{prefix}-#{line_number}",
          area_code:    area_code,
          prefix:       prefix,
          line_number:  line_number
        )

        expect(phone_number).to be_valid
      end

      it "must accept 'NNN-NNNN'" do
        phone_number = described_class.new(
          number:      "#{prefix}-#{line_number}",
          prefix:       prefix,
          line_number:  line_number
        )

        expect(phone_number).to be_valid
      end

      it "must accept '+N.NNN.NNN.NNNN'" do
        phone_number = described_class.new(
          number:      "+#{country_code}.#{area_code}.#{prefix}.#{line_number}",
          country_code: country_code,
          area_code:    area_code,
          prefix:       prefix,
          line_number:  line_number
        )

        expect(phone_number).to be_valid
      end

      it "must accept '+NN.NNN.NNN.NNNN'" do
        country_code = '01'

        phone_number = described_class.new(
          number:      "+#{country_code}.#{area_code}.#{prefix}.#{line_number}",
          country_code: country_code,
          area_code:    area_code,
          prefix:       prefix,
          line_number:  line_number
        )

        expect(phone_number).to be_valid
      end

      it "must accept 'N.NNN.NNN.NNNN'" do
        phone_number = described_class.new(
          number:      "#{country_code}.#{area_code}.#{prefix}.#{line_number}",
          country_code: country_code,
          area_code:    area_code,
          prefix:       prefix,
          line_number:  line_number
        )

        expect(phone_number).to be_valid
      end

      it "must accept 'NN.NNN.NNN.NNNN'" do
        country_code = '01'

        phone_number = described_class.new(
          number:      "#{country_code}.#{area_code}.#{prefix}.#{line_number}",
          country_code: country_code,
          area_code:    area_code,
          prefix:       prefix,
          line_number:  line_number
        )

        expect(phone_number).to be_valid
      end

      it "must accept 'NNN.NNN.NNNN'" do
        phone_number = described_class.new(
          number:      "#{area_code}.#{prefix}.#{line_number}",
          area_code:    area_code,
          prefix:       prefix,
          line_number:  line_number
        )

        expect(phone_number).to be_valid
      end

      it "must accept 'NNN.NNNN'" do
        phone_number = described_class.new(
          number:      "#{prefix}.#{line_number}",
          prefix:       prefix,
          line_number:  line_number
        )

        expect(phone_number).to be_valid
      end

      it "must accept '+N (NNN) NNN NNNN'" do
        phone_number = described_class.new(
          number:      "+#{country_code} (#{area_code}) #{prefix} #{line_number}",
          country_code: country_code,
          area_code:    area_code,
          prefix:       prefix,
          line_number:  line_number
        )

        expect(phone_number).to be_valid
      end

      it "must accept '+NN (NNN) NNN NNNN'" do
        country_code = '01'

        phone_number = described_class.new(
          number:      "+#{country_code} (#{area_code}) #{prefix} #{line_number}",
          country_code: country_code,
          area_code:    area_code,
          prefix:       prefix,
          line_number:  line_number
        )

        expect(phone_number).to be_valid
      end

      it "must accept 'N (NNN) NNN NNNN'" do
        phone_number = described_class.new(
          number:      "#{country_code} (#{area_code}) #{prefix} #{line_number}",
          country_code: country_code,
          area_code:    area_code,
          prefix:       prefix,
          line_number:  line_number
        )

        expect(phone_number).to be_valid
      end

      it "must accept 'NN (NNN) NNN NNNN'" do
        country_code = '01'

        phone_number = described_class.new(
          number:      "#{country_code} (#{area_code}) #{prefix} #{line_number}",
          country_code: country_code,
          area_code:    area_code,
          prefix:       prefix,
          line_number:  line_number
        )

        expect(phone_number).to be_valid
      end

      it "must accept '(NNN) NNN NNNN'" do
        phone_number = described_class.new(
          number:      "(#{area_code}) #{prefix} #{line_number}",
          area_code:    area_code,
          prefix:       prefix,
          line_number:  line_number
        )

        expect(phone_number).to be_valid
      end

      it "must accept '+N NNN NNN NNNN'" do
        phone_number = described_class.new(
          number:      "+#{country_code} #{area_code} #{prefix} #{line_number}",
          country_code: country_code,
          area_code:    area_code,
          prefix:       prefix,
          line_number:  line_number
        )

        expect(phone_number).to be_valid
      end

      it "must accept '+NN NNN NNN NNNN'" do
        country_code = '01'

        phone_number = described_class.new(
          number:      "+#{country_code} #{area_code} #{prefix} #{line_number}",
          country_code: country_code,
          area_code:    area_code,
          prefix:       prefix,
          line_number:  line_number
        )

        expect(phone_number).to be_valid
      end

      it "must accept 'N NNN NNN NNNN'" do
        phone_number = described_class.new(
          number:      "#{country_code} #{area_code} #{prefix} #{line_number}",
          country_code: country_code,
          area_code:    area_code,
          prefix:       prefix,
          line_number:  line_number
        )

        expect(phone_number).to be_valid
      end

      it "must accept 'NN NNN NNN NNNN'" do
        country_code = '01'

        phone_number = described_class.new(
          number:      "#{country_code} #{area_code} #{prefix} #{line_number}",
          country_code: country_code,
          area_code:    area_code,
          prefix:       prefix,
          line_number:  line_number
        )

        expect(phone_number).to be_valid
      end

      it "must accept 'NNN NNN NNNN'" do
        phone_number = described_class.new(
          number:      "#{area_code} #{prefix} #{line_number}",
          area_code:    area_code,
          prefix:       prefix,
          line_number:  line_number
        )

        expect(phone_number).to be_valid
      end

      it "must accept 'NNN NNNN'" do
        phone_number = described_class.new(
          number:      "#{prefix} #{line_number}",
          prefix:       prefix,
          line_number:  line_number
        )

        expect(phone_number).to be_valid
      end

      it "must not accept non-numbers" do
        phone_number = described_class.new(
          number:      'ABC',
          area_code:    area_code,
          prefix:       prefix,
          line_number:  line_number
        )

        expect(phone_number).to_not be_valid
        expect(phone_number.errors[:number]).to eq(
          ['must be a valid phone number']
        )
      end
    end

    context "when #country_code is set" do
      it "must accept a single digit country code" do
        phone_number = described_class.new(
          number:       number,
          country_code: '1',
          area_code:    area_code,
          prefix:       prefix,
          line_number:  line_number
        )

        expect(phone_number).to be_valid
      end

      it "must accept a two digit country code" do
        phone_number = described_class.new(
          number:       number,
          country_code: '01',
          area_code:    area_code,
          prefix:       prefix,
          line_number:  line_number
        )

        expect(phone_number).to be_valid
      end

      it "must not accept three or more digits" do
        phone_number = described_class.new(
          number:       number,
          country_code: '111',
          area_code:    area_code,
          prefix:       prefix,
          line_number:  line_number
        )

        expect(phone_number).to_not be_valid
        expect(phone_number.errors[:country_code]).to eq(
          ['must be a valid country code number']
        )
      end

      it "must not accept non-numbers" do
        phone_number = described_class.new(
          number:       number,
          country_code: 'A',
          area_code:    area_code,
          prefix:       prefix,
          line_number:  line_number
        )

        expect(phone_number).to_not be_valid
        expect(phone_number.errors[:country_code]).to eq(
          ['must be a valid country code number']
        )
      end
    end

    context "when #area_code is set" do
      it "must accept a three digit area code" do
        phone_number = described_class.new(
          number:       number,
          country_code: country_code,
          area_code:    '555',
          prefix:       prefix,
          line_number:  line_number
        )

        expect(phone_number).to be_valid
      end

      it "must not accept four or more digits" do
        phone_number = described_class.new(
          number:       number,
          country_code: country_code,
          area_code:    '5555',
          prefix:       prefix,
          line_number:  line_number
        )

        expect(phone_number).to_not be_valid
        expect(phone_number.errors[:area_code]).to eq(
          ['must be a valid area code number']
        )
      end

      it "must not accept non-numbers" do
        phone_number = described_class.new(
          number:       number,
          country_code: country_code,
          area_code:    'A',
          prefix:       prefix,
          line_number:  line_number
        )

        expect(phone_number).to_not be_valid
        expect(phone_number.errors[:area_code]).to eq(
          ['must be a valid area code number']
        )
      end
    end

    it "must require a #prefix" do
      phone_number = described_class.new(
        number:       number,
        country_code: country_code,
        area_code:    area_code,
        line_number:  line_number
      )

      expect(phone_number).to_not be_valid
      expect(phone_number.errors[:prefix]).to include("can't be blank")
    end

    it "must require a valid three digit #prefix" do
      phone_number = described_class.new(
        number:       number,
        country_code: country_code,
        area_code:    area_code,
        prefix:       'ABC',
        line_number:  line_number
      )

      expect(phone_number).to_not be_valid
      expect(phone_number.errors[:prefix]).to eq(
        ['must be a valid prefix number']
      )

      phone_number = described_class.new(
        number:       number,
        country_code: country_code,
        area_code:    area_code,
        prefix:       '1111',
        line_number:  line_number
      )

      expect(phone_number).to_not be_valid
      expect(phone_number.errors[:prefix]).to eq(
        ['must be a valid prefix number']
      )

      phone_number = described_class.new(
        number:       number,
        country_code: country_code,
        area_code:    area_code,
        prefix:       prefix,
        line_number:  line_number
      )

      expect(phone_number).to be_valid
    end

    it "must require a #line_number" do
      phone_number = described_class.new(
        number:       number,
        country_code: country_code,
        area_code:    area_code,
        prefix:       prefix
      )

      expect(phone_number).to_not be_valid
      expect(phone_number.errors[:line_number]).to include("can't be blank")
    end

    it "must require a valid four digit #line_number" do
      phone_number = described_class.new(
        number:       number,
        country_code: country_code,
        area_code:    area_code,
        prefix:       prefix,
        line_number:  'ABC'
      )

      expect(phone_number).to_not be_valid
      expect(phone_number.errors[:line_number]).to eq(
        ['must be a valid line number']
      )

      phone_number = described_class.new(
        number:       number,
        country_code: country_code,
        area_code:    area_code,
        prefix:       prefix,
        line_number:  '11111'
      )

      expect(phone_number).to_not be_valid
      expect(phone_number.errors[:line_number]).to eq(
        ['must be a valid line number']
      )

      phone_number = described_class.new(
        number:       number,
        country_code: country_code,
        area_code:    area_code,
        prefix:       prefix,
        line_number:  line_number
      )

      expect(phone_number).to be_valid
    end

    after { described_class.destroy_all }
  end

  describe ".lookup" do
    before do
      described_class.create(
        number: '555-555-0111',

        area_code:    '555',
        prefix:       '555',
        line_number:  '0111'
      )

      described_class.create(
        number: number,

        country_code: country_code,
        area_code:    area_code,
        prefix:       prefix,
        line_number:  line_number
      )

      described_class.create(
        number: '555-555-0122',

        area_code:    '555',
        country_code: '1',
        prefix:       '555',
        line_number:  '0122'
      )
    end

    it "must query the #{described_class} with the matching phone number" do
      phone_number = described_class.lookup(number)

      expect(phone_number).to be_kind_of(described_class)
      expect(phone_number.number).to eq(number)
    end

    after { described_class.destroy_all }
  end

  describe ".parse" do
    subject { described_class.parse(number) }

    it "must return a Hash of attributes" do
      expect(subject).to be_kind_of(Hash)
      expect(subject).to_not be_empty
    end

    it "must also return the original number" do
      expect(subject[:number]).to eq(number)
    end

    context "when given a '+N-NNN-NNN-NNNN' phone number" do
      let(:number) { "+#{country_code}-#{area_code}-#{prefix}-#{line_number}" }

      it "must extract the country code" do
        expect(subject[:country_code]).to eq(country_code)
      end

      it "must extract the area code" do
        expect(subject[:area_code]).to eq(area_code)
      end

      it "must extract the prefix" do
        expect(subject[:prefix]).to eq(prefix)
      end

      it "must extract the line number" do
        expect(subject[:line_number]).to eq(line_number)
      end
    end

    context "when given a '+NN-NNN-NNN-NNNN' phone number" do
      let(:country_code) { '01' }
      let(:number)       { "+#{country_code}-#{area_code}-#{prefix}-#{line_number}" }

      it "must extract the country code" do
        expect(subject[:country_code]).to eq(country_code)
      end

      it "must extract the area code" do
        expect(subject[:area_code]).to eq(area_code)
      end

      it "must extract the prefix" do
        expect(subject[:prefix]).to eq(prefix)
      end

      it "must extract the line number" do
        expect(subject[:line_number]).to eq(line_number)
      end
    end

    context "when given a 'N-NNN-NNN-NNNN' phone number" do
      let(:number) { "#{country_code}-#{area_code}-#{prefix}-#{line_number}" }

      it "must extract the country code" do
        expect(subject[:country_code]).to eq(country_code)
      end

      it "must extract the area code" do
        expect(subject[:area_code]).to eq(area_code)
      end

      it "must extract the prefix" do
        expect(subject[:prefix]).to eq(prefix)
      end

      it "must extract the line number" do
        expect(subject[:line_number]).to eq(line_number)
      end
    end

    context "when given a 'NN-NNN-NNN-NNNN' phone number" do
      let(:country_code) { '01' }
      let(:number)       { "#{country_code}-#{area_code}-#{prefix}-#{line_number}" }

      it "must extract the country code" do
        expect(subject[:country_code]).to eq(country_code)
      end

      it "must extract the area code" do
        expect(subject[:area_code]).to eq(area_code)
      end

      it "must extract the prefix" do
        expect(subject[:prefix]).to eq(prefix)
      end

      it "must extract the line number" do
        expect(subject[:line_number]).to eq(line_number)
      end
    end

    context "when given a 'NNN-NNN-NNNN' phone number" do
      let(:number) { "#{area_code}-#{prefix}-#{line_number}" }

      it "must set :country_code to nil" do
        expect(subject[:country_code]).to be(nil)
      end

      it "must extract the area code" do
        expect(subject[:area_code]).to eq(area_code)
      end

      it "must extract the prefix" do
        expect(subject[:prefix]).to eq(prefix)
      end

      it "must extract the line number" do
        expect(subject[:line_number]).to eq(line_number)
      end
    end

    context "when given a 'NNN-NNNN' phone number" do
      let(:number) { "#{prefix}-#{line_number}" }

      it "must set :country_code to nil" do
        expect(subject[:country_code]).to be(nil)
      end

      it "must set :area_code to nil" do
        expect(subject[:area_code]).to be(nil)
      end

      it "must extract the prefix" do
        expect(subject[:prefix]).to eq(prefix)
      end

      it "must extract the line number" do
        expect(subject[:line_number]).to eq(line_number)
      end
    end

    context "when given a '+N.NNN.NNN.NNNN' phone number" do
      let(:number) { "+#{country_code}.#{area_code}.#{prefix}.#{line_number}" }

      it "must extract the country code" do
        expect(subject[:country_code]).to eq(country_code)
      end

      it "must extract the area code" do
        expect(subject[:area_code]).to eq(area_code)
      end

      it "must extract the prefix" do
        expect(subject[:prefix]).to eq(prefix)
      end

      it "must extract the line number" do
        expect(subject[:line_number]).to eq(line_number)
      end
    end

    context "when given a '+NN.NNN.NNN.NNNN' phone number" do
      let(:country_code) { '01' }
      let(:number)       { "+#{country_code}.#{area_code}.#{prefix}.#{line_number}" }

      it "must extract the country code" do
        expect(subject[:country_code]).to eq(country_code)
      end

      it "must extract the area code" do
        expect(subject[:area_code]).to eq(area_code)
      end

      it "must extract the prefix" do
        expect(subject[:prefix]).to eq(prefix)
      end

      it "must extract the line number" do
        expect(subject[:line_number]).to eq(line_number)
      end
    end

    context "when given a 'N.NNN.NNN.NNNN' phone number" do
      let(:number) { "#{country_code}.#{area_code}.#{prefix}.#{line_number}" }

      it "must extract the country code" do
        expect(subject[:country_code]).to eq(country_code)
      end

      it "must extract the area code" do
        expect(subject[:area_code]).to eq(area_code)
      end

      it "must extract the prefix" do
        expect(subject[:prefix]).to eq(prefix)
      end

      it "must extract the line number" do
        expect(subject[:line_number]).to eq(line_number)
      end
    end

    context "when given a 'NN.NNN.NNN.NNNN' phone number" do
      let(:country_code) { '01' }
      let(:number)       { "#{country_code}.#{area_code}.#{prefix}.#{line_number}" }

      it "must extract the country code" do
        expect(subject[:country_code]).to eq(country_code)
      end

      it "must extract the area code" do
        expect(subject[:area_code]).to eq(area_code)
      end

      it "must extract the prefix" do
        expect(subject[:prefix]).to eq(prefix)
      end

      it "must extract the line number" do
        expect(subject[:line_number]).to eq(line_number)
      end
    end

    context "when given a 'NNN.NNN.NNNN' phone number" do
      let(:number) { "#{area_code}.#{prefix}.#{line_number}" }

      it "must set :country_code to nil" do
        expect(subject[:country_code]).to be(nil)
      end

      it "must extract the area code" do
        expect(subject[:area_code]).to eq(area_code)
      end

      it "must extract the prefix" do
        expect(subject[:prefix]).to eq(prefix)
      end

      it "must extract the line number" do
        expect(subject[:line_number]).to eq(line_number)
      end
    end

    context "when given a 'NNN.NNNN' phone number" do
      let(:number) { "#{prefix}.#{line_number}" }

      it "must set :country_code to nil" do
        expect(subject[:country_code]).to be(nil)
      end

      it "must set :area_code to nil" do
        expect(subject[:area_code]).to be(nil)
      end

      it "must extract the prefix" do
        expect(subject[:prefix]).to eq(prefix)
      end

      it "must extract the line number" do
        expect(subject[:line_number]).to eq(line_number)
      end
    end

    context "when given a '+N (NNN) NNN NNNN' phone number" do
      let(:number) { "+#{country_code} (#{area_code}) #{prefix} #{line_number}" }

      it "must extract the country code" do
        expect(subject[:country_code]).to eq(country_code)
      end

      it "must extract the area code" do
        expect(subject[:area_code]).to eq(area_code)
      end

      it "must extract the prefix" do
        expect(subject[:prefix]).to eq(prefix)
      end

      it "must extract the line number" do
        expect(subject[:line_number]).to eq(line_number)
      end
    end

    context "when given a '+NN (NNN) NNN NNNN' phone number" do
      let(:country_code) { '01' }
      let(:number)       { "+#{country_code} (#{area_code}) #{prefix} #{line_number}" }

      it "must extract the country code" do
        expect(subject[:country_code]).to eq(country_code)
      end

      it "must extract the area code" do
        expect(subject[:area_code]).to eq(area_code)
      end

      it "must extract the prefix" do
        expect(subject[:prefix]).to eq(prefix)
      end

      it "must extract the line number" do
        expect(subject[:line_number]).to eq(line_number)
      end
    end

    context "when given a 'N (NNN) NNN NNNN' phone number" do
      let(:number) { "#{country_code} (#{area_code}) #{prefix} #{line_number}" }

      it "must extract the country code" do
        expect(subject[:country_code]).to eq(country_code)
      end

      it "must extract the area code" do
        expect(subject[:area_code]).to eq(area_code)
      end

      it "must extract the prefix" do
        expect(subject[:prefix]).to eq(prefix)
      end

      it "must extract the line number" do
        expect(subject[:line_number]).to eq(line_number)
      end
    end

    context "when given a 'NN (NNN) NNN NNNN' phone number" do
      let(:country_code) { '01' }
      let(:number)       { "#{country_code} (#{area_code}) #{prefix} #{line_number}" }

      it "must extract the country code" do
        expect(subject[:country_code]).to eq(country_code)
      end

      it "must extract the area code" do
        expect(subject[:area_code]).to eq(area_code)
      end

      it "must extract the prefix" do
        expect(subject[:prefix]).to eq(prefix)
      end

      it "must extract the line number" do
        expect(subject[:line_number]).to eq(line_number)
      end
    end

    context "when given a '(NNN) NNN NNNN' phone number" do
      let(:number) { "(#{area_code}) #{prefix} #{line_number}" }

      it "must set :country_code to nil" do
        expect(subject[:country_code]).to be(nil)
      end

      it "must extract the area code" do
        expect(subject[:area_code]).to eq(area_code)
      end

      it "must extract the prefix" do
        expect(subject[:prefix]).to eq(prefix)
      end

      it "must extract the line number" do
        expect(subject[:line_number]).to eq(line_number)
      end
    end

    context "when given a 'N NNN NNN NNNN' phone number" do
      let(:number) { "#{country_code} #{area_code} #{prefix} #{line_number}" }

      it "must extract the country code" do
        expect(subject[:country_code]).to eq(country_code)
      end

      it "must extract the area code" do
        expect(subject[:area_code]).to eq(area_code)
      end

      it "must extract the prefix" do
        expect(subject[:prefix]).to eq(prefix)
      end

      it "must extract the line number" do
        expect(subject[:line_number]).to eq(line_number)
      end
    end

    context "when given a 'NN NNN NNN NNNN' phone number" do
      let(:country_code) { '01' }
      let(:number)       { "#{country_code} #{area_code} #{prefix} #{line_number}" }

      it "must extract the country code" do
        expect(subject[:country_code]).to eq(country_code)
      end

      it "must extract the area code" do
        expect(subject[:area_code]).to eq(area_code)
      end

      it "must extract the prefix" do
        expect(subject[:prefix]).to eq(prefix)
      end

      it "must extract the line number" do
        expect(subject[:line_number]).to eq(line_number)
      end
    end

    context "when given a 'NNN NNN NNNN' phone number" do
      let(:number) { "#{area_code} #{prefix} #{line_number}" }

      it "must set :country_code to nil" do
        expect(subject[:country_code]).to be(nil)
      end

      it "must extract the area code" do
        expect(subject[:area_code]).to eq(area_code)
      end

      it "must extract the prefix" do
        expect(subject[:prefix]).to eq(prefix)
      end

      it "must extract the line number" do
        expect(subject[:line_number]).to eq(line_number)
      end
    end

    context "when given a 'NNN NNNN' phone number" do
      let(:number) { "#{prefix} #{line_number}" }

      it "must set :country_code to nil" do
        expect(subject[:country_code]).to be(nil)
      end

      it "must set :area_code to nil" do
        expect(subject[:area_code]).to be(nil)
      end

      it "must extract the prefix" do
        expect(subject[:prefix]).to eq(prefix)
      end

      it "must extract the line number" do
        expect(subject[:line_number]).to eq(line_number)
      end
    end
  end

  describe ".import" do
    subject { described_class.import(number) }

    it "must import the #{described_class} and set #number" do
      expect(subject).to be_kind_of(described_class)
      expect(subject.id).to_not be(nil)
      expect(subject.number).to eq(number)
    end

    after { described_class.destroy_all }
  end

  subject do
    described_class.new(
      number: number,

      country_code: country_code,
      area_code:    area_code,
      prefix:       prefix,
      line_number:  line_number
    )
  end

  describe "#to_s" do
    it "must return #number" do
      expect(subject.to_s).to eq(number)
    end
  end
end
