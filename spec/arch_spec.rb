require 'spec_helper'
require 'ronin/db/arch'

describe Ronin::DB::Arch do
  it "must use the 'ronin_arches' table" do
    expect(described_class.table_name).to eq('ronin_arches')
  end

  let(:name)      { 'cats'  }
  let(:endian)    { :little }
  let(:word_size) { 4       }

  it "must include Ronin::DB::Model" do
    expect(described_class).to include(Ronin::DB::Model)
  end

  it "must include Ronin::DB::Model::HasUniqueName" do
    expect(described_class).to include(Ronin::DB::Model::HasUniqueName)
  end

  describe "validations" do
    describe "name" do
      it "must requier a name" do
        arch = described_class.new(endian: endian, word_size: word_size)
        expect(arch).to_not be_valid
        expect(arch.errors[:name]).to eq(
          ["can't be blank"]
        )

        arch = described_class.new(
          name:      name,
          endian:    endian,
          word_size: word_size
        )
        expect(arch).to be_valid
      end
    end

    describe "endian" do
      subject do
        described_class.new(
          name:      name,
          word_size: word_size
        )
      end

      it "must accept :little" do
        arch = described_class.new(
          name:      name,
          endian:    :little,
          word_size: word_size
        )
        expect(arch).to be_valid
      end

      it "must accept :big" do
        arch = described_class.new(
          name:      name,
          endian:    :big,
          word_size: word_size
        )
        expect(arch).to be_valid
      end

      context "otherwise" do
        let(:endian) { :foo }

        it do
          expect {
            described_class.new(
              name:      name,
              endian:    endian,
              word_size: word_size
            )
          }.to raise_error(ArgumentError,"'#{endian}' is not a valid endian")
        end
      end
    end

    describe "word_size" do
      it "must require a word_size" do
        arch = described_class.new(name: name, endian: endian)
        expect(arch).to_not be_valid
        expect(arch.errors[:word_size]).to include("can't be blank")

        arch = described_class.new(
          name:      name,
          endian:    endian,
          word_size: word_size
        )
        expect(arch).to be_valid
      end

      it "must accept a word_size of 4" do
        arch = described_class.new(
          name:      name,
          endian:    endian,
          word_size: 4 
        )
        expect(arch).to be_valid
      end

      it "must accept a word_size of 8" do
        arch = described_class.new(
          name:      name,
          endian:    endian,
          word_size: 8 
        )
        expect(arch).to be_valid
      end

      context "otherwise" do
        let(:word_size) { 3 }

        it do
          arch = described_class.new(
            name:      name,
            endian:    endian,
            word_size: word_size
          )
          expect(arch).to_not be_valid
          expect(arch.errors[:word_size]).to eq(
            ['is not included in the list']
          )
        end
      end
    end
  end

  describe ".x86" do
    subject { described_class.x86 }

    it "should return the x86 architecture" do
      expect(subject).to be_kind_of(described_class)
      expect(subject.name).to eq('x86')
    end
  end

  describe ".i686" do
    subject { described_class.i686 }

    it "should return the i686 architecture" do
      expect(subject).to be_kind_of(described_class)
      expect(subject.name).to eq('i686')
    end
  end

  describe ".x86_64" do
    subject { described_class.x86_64 }

    it "should return the x86-64 architecture" do
      expect(subject).to be_kind_of(described_class)
      expect(subject.name).to eq('x86-64')
    end
  end

  describe ".ppc" do
    subject { described_class.ppc }

    it "should return the PPC architecture" do
      expect(subject).to be_kind_of(described_class)
      expect(subject.name).to eq('PPC')
    end
  end

  describe ".ppc64" do
    subject { described_class.ppc64 }

    it "should return the PPC64 architecture" do
      expect(subject).to be_kind_of(described_class)
      expect(subject.name).to eq('PPC64')
    end
  end

  describe ".mips" do
    subject { described_class.mips }

    it "should return the MIPS architecture" do
      expect(subject).to be_kind_of(described_class)
      expect(subject.name).to eq('MIPS')
    end
  end

  describe ".mips_le" do
    subject { described_class.mips_le }

    it "should return the MIPS (Little-Endian) architecture" do
      expect(subject).to be_kind_of(described_class)
      expect(subject.name).to eq('MIPS (Little-Endian)')
    end
  end

  describe ".mips_be" do
    subject { described_class.mips_be }

    it "should return the MIPS (Big-Endian) architecture" do
      expect(subject).to be_kind_of(described_class)
      expect(subject.name).to eq('MIPS (Big-Endian)')
    end
  end

  describe ".arm" do
    subject { described_class.arm }

    it "should return the ARM architecture" do
      expect(subject).to be_kind_of(described_class)
      expect(subject.name).to eq('ARM')
    end
  end

  describe ".arm_le" do
    subject { described_class.arm_le }

    it "should return the ARM (Little-Endian) architecture" do
      expect(subject).to be_kind_of(described_class)
      expect(subject.name).to eq('ARM (Little-Endian)')
    end
  end

  describe ".arm_be" do
    subject { described_class.arm_be }

    it "should return the ARM (Big-Endian) architecture" do
      expect(subject).to be_kind_of(described_class)
      expect(subject.name).to eq('ARM (Big-Endian)')
    end
  end
end
