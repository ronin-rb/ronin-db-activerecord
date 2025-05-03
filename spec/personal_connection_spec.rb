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
      %w[
        friend
        collegue
        coworker

        parent
        mother
        father
        aunt
        uncle
        brother
        sister
        cousin
        nephew
        niece

        stepmother
        stepfather
        stepchild
        stepbrother
        stepsister

        in-law
        father-in-law
        mother-in-law

        partner
        boyfriend
        girlfriend
        husband
        wife

        ex
        ex-husband
        ex-wife
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
        connection = described_class.new(
          type:         'other',
          person:       person1,
          other_person: person2
        )

        expect(connection).to_not be_valid
        expect(connection.errors[:type]).to eq(['is not included in the list'])
      end
    end
  end

  describe "#is_friend?" do
    context "when #type is 'friend'" do
      let(:type) { 'friend' }

      it "must return true" do
        expect(subject.is_friend?).to be(true)
      end
    end

    context "when #type is not 'friend'" do
      let(:type) { 'ex' }

      it "must return false" do
        expect(subject.is_friend?).to be(false)
      end
    end
  end

  describe "#is_collegue?" do
    context "when #type is 'collegue'" do
      let(:type) { 'collegue' }

      it "must return true" do
        expect(subject.is_collegue?).to be(true)
      end
    end

    context "when #type is not 'collegue'" do
      let(:type) { 'ex' }

      it "must return false" do
        expect(subject.is_collegue?).to be(false)
      end
    end
  end

  describe "#is_coworker?" do
    context "when #type is 'coworker'" do
      let(:type) { 'coworker' }

      it "must return true" do
        expect(subject.is_coworker?).to be(true)
      end
    end

    context "when #type is not 'coworker'" do
      let(:type) { 'ex' }

      it "must return false" do
        expect(subject.is_coworker?).to be(false)
      end
    end
  end

  describe "#is_parent?" do
    context "when #type is 'parent'" do
      let(:type) { 'parent' }

      it "must return true" do
        expect(subject.is_parent?).to be(true)
      end
    end

    context "when #type is not 'parent'" do
      let(:type) { 'ex' }

      it "must return false" do
        expect(subject.is_parent?).to be(false)
      end
    end
  end

  describe "#is_mother?" do
    context "when #type is 'mother'" do
      let(:type) { 'mother' }

      it "must return true" do
        expect(subject.is_mother?).to be(true)
      end
    end

    context "when #type is not 'mother'" do
      let(:type) { 'ex' }

      it "must return false" do
        expect(subject.is_mother?).to be(false)
      end
    end
  end

  describe "#is_father?" do
    context "when #type is 'father'" do
      let(:type) { 'father' }

      it "must return true" do
        expect(subject.is_father?).to be(true)
      end
    end

    context "when #type is not 'father'" do
      let(:type) { 'ex' }

      it "must return false" do
        expect(subject.is_father?).to be(false)
      end
    end
  end

  describe "#is_aunt?" do
    context "when #type is 'aunt'" do
      let(:type) { 'aunt' }

      it "must return true" do
        expect(subject.is_aunt?).to be(true)
      end
    end

    context "when #type is not 'aunt'" do
      let(:type) { 'ex' }

      it "must return false" do
        expect(subject.is_aunt?).to be(false)
      end
    end
  end

  describe "#is_uncle?" do
    context "when #type is 'uncle'" do
      let(:type) { 'uncle' }

      it "must return true" do
        expect(subject.is_uncle?).to be(true)
      end
    end

    context "when #type is not 'uncle'" do
      let(:type) { 'ex' }

      it "must return false" do
        expect(subject.is_uncle?).to be(false)
      end
    end
  end

  describe "#is_brother?" do
    context "when #type is 'brother'" do
      let(:type) { 'brother' }

      it "must return true" do
        expect(subject.is_brother?).to be(true)
      end
    end

    context "when #type is not 'brother'" do
      let(:type) { 'ex' }

      it "must return false" do
        expect(subject.is_brother?).to be(false)
      end
    end
  end

  describe "#is_sister?" do
    context "when #type is 'sister'" do
      let(:type) { 'sister' }

      it "must return true" do
        expect(subject.is_sister?).to be(true)
      end
    end

    context "when #type is not 'sister'" do
      let(:type) { 'ex' }

      it "must return false" do
        expect(subject.is_sister?).to be(false)
      end
    end
  end

  describe "#is_cousin?" do
    context "when #type is 'cousin'" do
      let(:type) { 'cousin' }

      it "must return true" do
        expect(subject.is_cousin?).to be(true)
      end
    end

    context "when #type is not 'cousin'" do
      let(:type) { 'ex' }

      it "must return false" do
        expect(subject.is_cousin?).to be(false)
      end
    end
  end

  describe "#is_nephew?" do
    context "when #type is 'nephew'" do
      let(:type) { 'nephew' }

      it "must return true" do
        expect(subject.is_nephew?).to be(true)
      end
    end

    context "when #type is not 'nephew'" do
      let(:type) { 'ex' }

      it "must return false" do
        expect(subject.is_nephew?).to be(false)
      end
    end
  end

  describe "#is_niece?" do
    context "when #type is 'niece'" do
      let(:type) { 'niece' }

      it "must return true" do
        expect(subject.is_niece?).to be(true)
      end
    end

    context "when #type is not 'niece'" do
      let(:type) { 'ex' }

      it "must return false" do
        expect(subject.is_niece?).to be(false)
      end
    end
  end

  describe "#is_stepmother?" do
    context "when #type is 'stepmother'" do
      let(:type) { 'stepmother' }

      it "must return true" do
        expect(subject.is_stepmother?).to be(true)
      end
    end

    context "when #type is not 'stepmother'" do
      let(:type) { 'ex' }

      it "must return false" do
        expect(subject.is_stepmother?).to be(false)
      end
    end
  end

  describe "#is_stepfather?" do
    context "when #type is 'stepfather'" do
      let(:type) { 'stepfather' }

      it "must return true" do
        expect(subject.is_stepfather?).to be(true)
      end
    end

    context "when #type is not 'stepfather'" do
      let(:type) { 'ex' }

      it "must return false" do
        expect(subject.is_stepfather?).to be(false)
      end
    end
  end

  describe "#is_stepfather?" do
    context "when #type is 'stepfather'" do
      let(:type) { 'stepfather' }

      it "must return true" do
        expect(subject.is_stepfather?).to be(true)
      end
    end

    context "when #type is not 'stepfather'" do
      let(:type) { 'ex' }

      it "must return false" do
        expect(subject.is_stepfather?).to be(false)
      end
    end
  end

  describe "#is_stepchild?" do
    context "when #type is 'stepchild'" do
      let(:type) { 'stepchild' }

      it "must return true" do
        expect(subject.is_stepchild?).to be(true)
      end
    end

    context "when #type is not 'stepchild'" do
      let(:type) { 'ex' }

      it "must return false" do
        expect(subject.is_stepchild?).to be(false)
      end
    end
  end

  describe "#is_stepbrother?" do
    context "when #type is 'stepbrother'" do
      let(:type) { 'stepbrother' }

      it "must return true" do
        expect(subject.is_stepbrother?).to be(true)
      end
    end

    context "when #type is not 'stepbrother'" do
      let(:type) { 'ex' }

      it "must return false" do
        expect(subject.is_stepbrother?).to be(false)
      end
    end
  end

  describe "#is_stepsister?" do
    context "when #type is 'stepsister'" do
      let(:type) { 'stepsister' }

      it "must return true" do
        expect(subject.is_stepsister?).to be(true)
      end
    end

    context "when #type is not 'stepsister'" do
      let(:type) { 'ex' }

      it "must return false" do
        expect(subject.is_stepsister?).to be(false)
      end
    end
  end

  describe "#is_in_law?" do
    context "when #type is 'in-law'" do
      let(:type) { 'in-law' }

      it "must return true" do
        expect(subject.is_in_law?).to be(true)
      end
    end

    context "when #type is not 'in-law'" do
      let(:type) { 'ex' }

      it "must return false" do
        expect(subject.is_in_law?).to be(false)
      end
    end
  end

  describe "#is_father_in_law?" do
    context "when #type is 'father-in-law'" do
      let(:type) { 'father-in-law' }

      it "must return true" do
        expect(subject.is_father_in_law?).to be(true)
      end
    end

    context "when #type is not 'father-in-law'" do
      let(:type) { 'ex' }

      it "must return false" do
        expect(subject.is_father_in_law?).to be(false)
      end
    end
  end

  describe "#is_mother_in_law?" do
    context "when #type is 'mother-in-law'" do
      let(:type) { 'mother-in-law' }

      it "must return true" do
        expect(subject.is_mother_in_law?).to be(true)
      end
    end

    context "when #type is not 'mother-in-law'" do
      let(:type) { 'ex' }

      it "must return false" do
        expect(subject.is_mother_in_law?).to be(false)
      end
    end
  end

  describe "#is_partner?" do
    context "when #type is 'partner'" do
      let(:type) { 'partner' }

      it "must return true" do
        expect(subject.is_partner?).to be(true)
      end
    end

    context "when #type is not 'partner'" do
      let(:type) { 'ex' }

      it "must return false" do
        expect(subject.is_partner?).to be(false)
      end
    end
  end

  describe "#is_boyfriend?" do
    context "when #type is 'boyfriend'" do
      let(:type) { 'boyfriend' }

      it "must return true" do
        expect(subject.is_boyfriend?).to be(true)
      end
    end

    context "when #type is not 'boyfriend'" do
      let(:type) { 'ex' }

      it "must return false" do
        expect(subject.is_boyfriend?).to be(false)
      end
    end
  end

  describe "#is_girlfriend?" do
    context "when #type is 'girlfriend'" do
      let(:type) { 'girlfriend' }

      it "must return true" do
        expect(subject.is_girlfriend?).to be(true)
      end
    end

    context "when #type is not 'girlfriend'" do
      let(:type) { 'ex' }

      it "must return false" do
        expect(subject.is_girlfriend?).to be(false)
      end
    end
  end

  describe "#is_husband?" do
    context "when #type is 'husband'" do
      let(:type) { 'husband' }

      it "must return true" do
        expect(subject.is_husband?).to be(true)
      end
    end

    context "when #type is not 'husband'" do
      let(:type) { 'ex' }

      it "must return false" do
        expect(subject.is_husband?).to be(false)
      end
    end
  end

  describe "#is_wife?" do
    context "when #type is 'wife'" do
      let(:type) { 'wife' }

      it "must return true" do
        expect(subject.is_wife?).to be(true)
      end
    end

    context "when #type is not 'wife'" do
      let(:type) { 'ex' }

      it "must return false" do
        expect(subject.is_wife?).to be(false)
      end
    end
  end

  describe "#is_ex?" do
    context "when #type is 'ex'" do
      let(:type) { 'ex' }

      it "must return true" do
        expect(subject.is_ex?).to be(true)
      end
    end

    context "when #type is not 'ex'" do
      let(:type) { 'friend' }

      it "must return false" do
        expect(subject.is_ex?).to be(false)
      end
    end
  end

  describe "#is_ex_husband?" do
    context "when #type is 'ex-husband'" do
      let(:type) { 'ex-husband' }

      it "must return true" do
        expect(subject.is_ex_husband?).to be(true)
      end
    end

    context "when #type is not 'ex'" do
      let(:type) { 'friend' }

      it "must return false" do
        expect(subject.is_ex_husband?).to be(false)
      end
    end
  end

  describe "#is_ex_wife?" do
    context "when #type is 'ex-wife'" do
      let(:type) { 'ex-wife' }

      it "must return true" do
        expect(subject.is_ex_wife?).to be(true)
      end
    end

    context "when #type is not 'ex'" do
      let(:type) { 'friend' }

      it "must return false" do
        expect(subject.is_ex_wife?).to be(false)
      end
    end
  end
end
