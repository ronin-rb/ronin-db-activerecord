require 'spec_helper'
require 'ronin/db/person'

describe Ronin::DB::Person do
  it "must use the 'ronin_people' table" do
    expect(described_class.table_name).to eq('ronin_people')
  end

  let(:first_name) { 'John' }
  let(:last_name)  { 'Smith' }
  let(:full_name)  { "#{first_name} #{last_name}" }

  let(:middle_name)    { 'Johnson' }
  let(:middle_initial) { middle_name.chars.first }

  let(:prefix) { 'Sir' }
  let(:suffix) { 'Jr' }

  describe "validations" do
    it "must require a #full_name" do
      person = described_class.new(
        first_name: first_name
      )

      expect(person).to_not be_valid
      expect(person.errors[:full_name]).to include("can't be blank")
    end

    describe "full_name" do
      it "must accept 'first-name'" do
        person = described_class.new(
          full_name:  first_name,
          first_name: first_name
        )

        expect(person).to be_valid
      end

      it "must accept 'first-name last-name'" do
        person = described_class.new(
          full_name:  "#{first_name} #{last_name}",
          first_name: first_name,
          last_name:  last_name
        )

        expect(person).to be_valid
      end

      it "must accept 'first-name middle-initial last-name'" do
        person = described_class.new(
          full_name:     "#{first_name} #{middle_initial} #{last_name}",
          first_name:     first_name,
          middle_initial: middle_initial,
          last_name:      last_name
        )

        expect(person).to be_valid
      end

      it "must accept 'first-name middle-initial. last-name'" do
        person = described_class.new(
          full_name:     "#{first_name} #{middle_initial}. #{last_name}",
          first_name:     first_name,
          middle_initial: middle_initial,
          last_name:      last_name
        )

        expect(person).to be_valid
      end

      it "must accept 'first-name middle-name last-name'" do
        person = described_class.new(
          full_name:     "#{first_name} #{middle_name} #{last_name}",
          first_name:     first_name,
          middle_name:    middle_name,
          middle_initial: middle_initial,
          last_name:      last_name
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix first-name'" do
        person = described_class.new(
          full_name:  "#{prefix} #{first_name}",
          prefix:     prefix,
          first_name: first_name
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix first-name last-name'" do
        person = described_class.new(
          full_name:  "#{prefix} #{first_name} #{last_name}",
          prefix:     prefix,
          first_name: first_name,
          last_name:  last_name
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix first-name middle-initial last-name'" do
        person = described_class.new(
          full_name:      "#{prefix} #{first_name} #{middle_initial} #{last_name}",
          prefix:         prefix,
          first_name:     first_name,
          middle_initial: middle_initial,
          last_name:      last_name
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix first-name middle-initial. last-name'" do
        person = described_class.new(
          full_name:      "#{prefix} #{first_name} #{middle_initial}. #{last_name}",
          prefix:         prefix,
          first_name:     first_name,
          middle_initial: middle_initial,
          last_name:      last_name
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix first-name middle-name last-name'" do
        person = described_class.new(
          full_name:      "#{prefix} #{first_name} #{middle_name} #{last_name}",
          prefix:         prefix,
          first_name:     first_name,
          middle_name:    middle_name,
          middle_initial: middle_initial,
          last_name:      last_name
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix. first-name'" do
        person = described_class.new(
          full_name:  "#{prefix}. #{first_name}",
          prefix:     prefix,
          first_name: first_name
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix. first-name last-name'" do
        person = described_class.new(
          full_name:  "#{prefix}. #{first_name} #{last_name}",
          prefix:     prefix,
          first_name: first_name,
          last_name:  last_name
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix. first-name middle-initial last-name'" do
        person = described_class.new(
          full_name:      "#{prefix}. #{first_name} #{middle_initial} #{last_name}",
          prefix:         prefix,
          first_name:     first_name,
          middle_initial: middle_initial,
          last_name:      last_name
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix. first-name middle-initial. last-name'" do
        person = described_class.new(
          full_name:      "#{prefix}. #{first_name} #{middle_initial}. #{last_name}",
          prefix:         prefix,
          first_name:     first_name,
          middle_initial: middle_initial,
          last_name:      last_name
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix. first-name middle-name last-name'" do
        person = described_class.new(
          full_name:      "#{prefix}. #{first_name} #{middle_name} #{last_name}",
          prefix:         prefix,
          first_name:     first_name,
          middle_name:    middle_name,
          middle_initial: middle_initial,
          last_name:      last_name
        )

        expect(person).to be_valid
      end

      it "must accept 'first-name last-name suffix'" do
        person = described_class.new(
          full_name:  "#{first_name} #{last_name} #{suffix}",
          first_name: first_name,
          last_name:  last_name,
          suffix:     suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'first-name middle-initial last-name suffix'" do
        person = described_class.new(
          full_name:     "#{first_name} #{middle_initial} #{last_name} #{suffix}",
          first_name:     first_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'first-name middle-initial. last-name suffix'" do
        person = described_class.new(
          full_name:     "#{first_name} #{middle_initial}. #{last_name} #{suffix}",
          first_name:     first_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'first-name middle-name last-name suffix'" do
        person = described_class.new(
          full_name:     "#{first_name} #{middle_name} #{last_name} #{suffix}",
          first_name:     first_name,
          middle_name:    middle_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'first-name last-name suffix.'" do
        person = described_class.new(
          full_name:  "#{first_name} #{last_name} #{suffix}.",
          first_name: first_name,
          last_name:  last_name,
          suffix:     suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'first-name middle-initial last-name suffix.'" do
        person = described_class.new(
          full_name:     "#{first_name} #{middle_initial} #{last_name} #{suffix}.",
          first_name:     first_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'first-name middle-initial. last-name suffix.'" do
        person = described_class.new(
          full_name:     "#{first_name} #{middle_initial}. #{last_name} #{suffix}.",
          first_name:     first_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'first-name middle-name last-name suffix.'" do
        person = described_class.new(
          full_name:     "#{first_name} #{middle_name} #{last_name} #{suffix}.",
          first_name:     first_name,
          middle_name:    middle_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'first-name last-name, suffix'" do
        person = described_class.new(
          full_name:  "#{first_name} #{last_name}, #{suffix}",
          first_name: first_name,
          last_name:  last_name,
          suffix:     suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'first-name middle-initial last-name, suffix'" do
        person = described_class.new(
          full_name:     "#{first_name} #{middle_initial} #{last_name}, #{suffix}",
          first_name:     first_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'first-name middle-initial. last-name, suffix'" do
        person = described_class.new(
          full_name:     "#{first_name} #{middle_initial}. #{last_name}, #{suffix}",
          first_name:     first_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'first-name middle-name last-name, suffix'" do
        person = described_class.new(
          full_name:     "#{first_name} #{middle_name} #{last_name}, #{suffix}",
          first_name:     first_name,
          middle_name:    middle_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'first-name last-name, suffix.'" do
        person = described_class.new(
          full_name:  "#{first_name} #{last_name}, #{suffix}.",
          first_name: first_name,
          last_name:  last_name,
          suffix:     suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'first-name middle-initial last-name, suffix.'" do
        person = described_class.new(
          full_name:     "#{first_name} #{middle_initial} #{last_name}, #{suffix}.",
          first_name:     first_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'first-name middle-initial. last-name, suffix.'" do
        person = described_class.new(
          full_name:     "#{first_name} #{middle_initial}. #{last_name}, #{suffix}.",
          first_name:     first_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'first-name middle-name last-name, suffix.'" do
        person = described_class.new(
          full_name:     "#{first_name} #{middle_name} #{last_name}, #{suffix}.",
          first_name:     first_name,
          middle_name:    middle_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix first-name last-name suffix'" do
        person = described_class.new(
          full_name:  "#{prefix} #{first_name} #{last_name} #{suffix}",
          prefix:     prefix,
          first_name: first_name,
          last_name:  last_name,
          suffix:     suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix first-name middle-initial last-name suffix'" do
        person = described_class.new(
          full_name:     "#{prefix} #{first_name} #{middle_initial} #{last_name} #{suffix}",
          prefix:         prefix,
          first_name:     first_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix first-name middle-initial. last-name suffix'" do
        person = described_class.new(
          full_name:     "#{prefix} #{first_name} #{middle_initial}. #{last_name} #{suffix}",
          prefix:         prefix,
          first_name:     first_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix first-name middle-name last-name suffix'" do
        person = described_class.new(
          full_name:     "#{prefix} #{first_name} #{middle_name} #{last_name} #{suffix}",
          prefix:         prefix,
          first_name:     first_name,
          middle_name:    middle_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix first-name last-name suffix.'" do
        person = described_class.new(
          full_name:  "#{prefix} #{first_name} #{last_name} #{suffix}.",
          prefix:     prefix,
          first_name: first_name,
          last_name:  last_name,
          suffix:     suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix first-name middle-initial last-name suffix.'" do
        person = described_class.new(
          full_name:     "#{prefix} #{first_name} #{middle_initial} #{last_name} #{suffix}.",
          prefix:         prefix,
          first_name:     first_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix first-name middle-initial. last-name suffix.'" do
        person = described_class.new(
          full_name:     "#{prefix} #{first_name} #{middle_initial}. #{last_name} #{suffix}.",
          prefix:         prefix,
          first_name:     first_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix first-name middle-name last-name suffix.'" do
        person = described_class.new(
          full_name:     "#{prefix} #{first_name} #{middle_name} #{last_name} #{suffix}.",
          prefix:         prefix,
          first_name:     first_name,
          middle_name:    middle_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix first-name last-name, suffix'" do
        person = described_class.new(
          full_name:  "#{prefix} #{first_name} #{last_name}, #{suffix}",
          prefix:     prefix,
          first_name: first_name,
          last_name:  last_name,
          suffix:     suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix first-name middle-initial last-name, suffix'" do
        person = described_class.new(
          full_name:     "#{prefix} #{first_name} #{middle_initial} #{last_name}, #{suffix}",
          prefix:         prefix,
          first_name:     first_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix first-name middle-initial. last-name, suffix'" do
        person = described_class.new(
          full_name:     "#{prefix} #{first_name} #{middle_initial}. #{last_name}, #{suffix}",
          prefix:         prefix,
          first_name:     first_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix first-name middle-name last-name, suffix'" do
        person = described_class.new(
          full_name:     "#{prefix} #{first_name} #{middle_name} #{last_name}, #{suffix}",
          prefix:         prefix,
          first_name:     first_name,
          middle_name:    middle_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix first-name last-name, suffix.'" do
        person = described_class.new(
          full_name:  "#{prefix} #{first_name} #{last_name}, #{suffix}.",
          prefix:     prefix,
          first_name: first_name,
          last_name:  last_name,
          suffix:     suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix first-name middle-initial last-name, suffix.'" do
        person = described_class.new(
          full_name:     "#{prefix} #{first_name} #{middle_initial} #{last_name}, #{suffix}.",
          prefix:         prefix,
          first_name:     first_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix first-name middle-initial. last-name, suffix.'" do
        person = described_class.new(
          full_name:     "#{prefix} #{first_name} #{middle_initial}. #{last_name}, #{suffix}.",
          prefix:         prefix,
          first_name:     first_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix first-name middle-name last-name, suffix.'" do
        person = described_class.new(
          full_name:     "#{prefix} #{first_name} #{middle_name} #{last_name}, #{suffix}.",
          prefix:         prefix,
          first_name:     first_name,
          middle_name:    middle_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix. first-name last-name suffix'" do
        person = described_class.new(
          full_name:  "#{prefix}. #{first_name} #{last_name} #{suffix}",
          prefix:     prefix,
          first_name: first_name,
          last_name:  last_name,
          suffix:     suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix. first-name middle-initial last-name suffix'" do
        person = described_class.new(
          full_name:     "#{prefix}. #{first_name} #{middle_initial} #{last_name} #{suffix}",
          prefix:         prefix,
          first_name:     first_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix. first-name middle-initial. last-name suffix'" do
        person = described_class.new(
          full_name:     "#{prefix}. #{first_name} #{middle_initial}. #{last_name} #{suffix}",
          prefix:         prefix,
          first_name:     first_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix. first-name middle-name last-name suffix'" do
        person = described_class.new(
          full_name:     "#{prefix}. #{first_name} #{middle_name} #{last_name} #{suffix}",
          prefix:         prefix,
          first_name:     first_name,
          middle_name:    middle_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix. first-name last-name suffix.'" do
        person = described_class.new(
          full_name:  "#{prefix}. #{first_name} #{last_name} #{suffix}.",
          prefix:     prefix,
          first_name: first_name,
          last_name:  last_name,
          suffix:     suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix. first-name middle-initial last-name suffix.'" do
        person = described_class.new(
          full_name:     "#{prefix}. #{first_name} #{middle_initial} #{last_name} #{suffix}.",
          prefix:         prefix,
          first_name:     first_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix. first-name middle-initial. last-name suffix.'" do
        person = described_class.new(
          full_name:     "#{prefix}. #{first_name} #{middle_initial}. #{last_name} #{suffix}.",
          prefix:         prefix,
          first_name:     first_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix. first-name middle-name last-name suffix.'" do
        person = described_class.new(
          full_name:     "#{prefix}. #{first_name} #{middle_name} #{last_name} #{suffix}.",
          prefix:         prefix,
          first_name:     first_name,
          middle_name:    middle_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix. first-name last-name, suffix'" do
        person = described_class.new(
          full_name:  "#{prefix} #{first_name} #{last_name}, #{suffix}",
          prefix:     prefix,
          first_name: first_name,
          last_name:  last_name,
          suffix:     suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix. first-name middle-initial last-name, suffix'" do
        person = described_class.new(
          full_name:     "#{prefix}. #{first_name} #{middle_initial} #{last_name}, #{suffix}",
          prefix:         prefix,
          first_name:     first_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix. first-name middle-initial. last-name, suffix'" do
        person = described_class.new(
          full_name:     "#{prefix}. #{first_name} #{middle_initial}. #{last_name}, #{suffix}",
          prefix:         prefix,
          first_name:     first_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix. first-name middle-name last-name, suffix'" do
        person = described_class.new(
          full_name:     "#{prefix}. #{first_name} #{middle_name} #{last_name}, #{suffix}",
          prefix:         prefix,
          first_name:     first_name,
          middle_name:    middle_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix. first-name last-name, suffix.'" do
        person = described_class.new(
          full_name:  "#{prefix}. #{first_name} #{last_name}, #{suffix}.",
          prefix:     prefix,
          first_name: first_name,
          last_name:  last_name,
          suffix:     suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix. first-name middle-initial last-name, suffix.'" do
        person = described_class.new(
          full_name:     "#{prefix}. #{first_name} #{middle_initial} #{last_name}, #{suffix}.",
          prefix:         prefix,
          first_name:     first_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix. first-name middle-initial. last-name, suffix.'" do
        person = described_class.new(
          full_name:     "#{prefix}. #{first_name} #{middle_initial}. #{last_name}, #{suffix}.",
          prefix:         prefix,
          first_name:     first_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end

      it "must accept 'prefix. first-name middle-name last-name, suffix.'" do
        person = described_class.new(
          full_name:     "#{prefix}. #{first_name} #{middle_name} #{last_name}, #{suffix}.",
          prefix:         prefix,
          first_name:     first_name,
          middle_name:    middle_name,
          middle_initial: middle_initial,
          last_name:      last_name,
          suffix:         suffix
        )

        expect(person).to be_valid
      end
    end

    it "must require a #first_name" do
      person = described_class.new(
        full_name: full_name
      )

      expect(person).to_not be_valid
      expect(person.errors[:first_name]).to include("can't be blank")
    end

    describe "prefix" do
      %w[Mr Mrs Ms Miss Dr Sir Madam Master Fr Rev Atty].each do |prefix|
        it "must accept '#{prefix}'" do
          person = described_class.new(
            full_name:  "#{prefix} #{full_name}",
            prefix:     prefix,
            first_name: first_name,
            last_name:  last_name
          )

          expect(person).to be_valid
        end
      end

      it "must not allow unknown suffixes" do
        person = described_class.new(
          full_name:   full_name,
          prefix:      'xXx',
          first_name:  first_name,
          last_name:   last_name
        )

        expect(person).to_not be_valid
        expect(person.errors[:prefix]).to eq(
          ["is not included in the list"]
        )
      end
    end

    describe "first_name" do
      it "must accept 'Name'" do
        person = described_class.new(
          full_name:  full_name,
          first_name: first_name,
          last_name:  last_name
        )

        expect(person).to be_valid
      end

      it "must accept 'Name-Name'" do
        person = described_class.new(
          full_name:  full_name,
          first_name: "John-Johnson",
          last_name:  last_name
        )

        expect(person).to be_valid
      end

      it "must accept 'Name-name'" do
        person = described_class.new(
          full_name:  full_name,
          first_name: "John-johnson",
          last_name:  last_name
        )

        expect(person).to be_valid
      end

      it "must accept \"O'Name\"" do
        person = described_class.new(
          full_name:  full_name,
          first_name: "O'Brian",
          last_name:  last_name
        )

        expect(person).to be_valid
      end

      it "must accept \"T'Name\"" do
        person = described_class.new(
          full_name:  full_name,
          first_name: "T'Quan",
          last_name:  last_name
        )

        expect(person).to be_valid
      end

      it "must accept \"Ta'Name\"" do
        person = described_class.new(
          full_name:  full_name,
          first_name: "Ta'Quan",
          last_name:  last_name
        )

        expect(person).to be_valid
      end

      it "must accept \"Te'Name\"" do
        person = described_class.new(
          full_name:  full_name,
          first_name: "Te'Quan",
          last_name:  last_name
        )

        expect(person).to be_valid
      end

      it "must accept \"K'Name\"" do
        person = described_class.new(
          full_name:  full_name,
          first_name: "K'neesha",
          last_name:  last_name
        )

        expect(person).to be_valid
      end

      it "must accept \"D'Name\"" do
        person = described_class.new(
          full_name:  full_name,
          first_name: "D'Angelo",
          last_name:  last_name
        )

        expect(person).to be_valid
      end

      it "must accept \"Di'Name\"" do
        person = described_class.new(
          full_name:  full_name,
          first_name: "Di'Angelo",
          last_name:  last_name
        )

        expect(person).to be_valid
      end

      it "must accept \"L'Name\"" do
        person = described_class.new(
          full_name:  full_name,
          first_name: "L'Boyce",
          last_name:  last_name
        )

        expect(person).to be_valid
      end

      it "must accept \"Le'Name\"" do
        person = described_class.new(
          full_name:  full_name,
          first_name: "Le'Bryan",
          last_name:  last_name
        )

        expect(person).to be_valid
      end

      it "must accept \"La'Name\"" do
        person = described_class.new(
          full_name:  full_name,
          first_name: "La'Michal",
          last_name:  last_name
        )

        expect(person).to be_valid
      end

      it "must not allow numbers in the #first_name" do
        person = described_class.new(
          full_name:  full_name,
          first_name: "#{first_name}1",
          last_name:  last_name
        )

        expect(person).to_not be_valid
        expect(person.errors[:first_name]).to eq(
          ["must be a valid first name"]
        )
      end
    end

    describe "middle_name" do
      it "must accept 'Name'" do
        person = described_class.new(
          full_name:   full_name,
          first_name:  first_name,
          middle_name: middle_name,
          last_name:   last_name
        )

        expect(person).to be_valid
      end

      it "must accept 'Name-Name'" do
        person = described_class.new(
          full_name:   full_name,
          first_name:  first_name,
          middle_name: "John-Johnson",
          last_name:   last_name
        )

        expect(person).to be_valid
      end

      it "must accept 'Name-name'" do
        person = described_class.new(
          full_name:   full_name,
          first_name:  first_name,
          middle_name: "John-johnson",
          last_name:   last_name
        )

        expect(person).to be_valid
      end

      it "must accept \"O'Name\"" do
        person = described_class.new(
          full_name:   full_name,
          first_name:  first_name,
          middle_name: "O'Brian",
          last_name:   last_name
        )

        expect(person).to be_valid
      end

      it "must accept \"T'Name\"" do
        person = described_class.new(
          full_name:   full_name,
          first_name:  first_name,
          middle_name: "T'Quan",
          last_name:   last_name
        )

        expect(person).to be_valid
      end

      it "must accept \"Ta'Name\"" do
        person = described_class.new(
          full_name:   full_name,
          first_name:  first_name,
          middle_name: "Ta'Quan",
          last_name:   last_name
        )

        expect(person).to be_valid
      end

      it "must accept \"Te'Name\"" do
        person = described_class.new(
          full_name:   full_name,
          first_name:  first_name,
          middle_name: "Te'Quan",
          last_name:   last_name
        )

        expect(person).to be_valid
      end

      it "must accept \"K'Name\"" do
        person = described_class.new(
          full_name:   full_name,
          first_name:  first_name,
          middle_name: "K'neesha",
          last_name:   last_name
        )

        expect(person).to be_valid
      end

      it "must accept \"D'Name\"" do
        person = described_class.new(
          full_name:   full_name,
          first_name:  first_name,
          middle_name: "D'Angelo",
          last_name:   last_name
        )

        expect(person).to be_valid
      end

      it "must accept \"Di'Name\"" do
        person = described_class.new(
          full_name:   full_name,
          first_name:  first_name,
          middle_name: "Di'Angelo",
          last_name:   last_name
        )

        expect(person).to be_valid
      end

      it "must accept \"L'Name\"" do
        person = described_class.new(
          full_name:   full_name,
          first_name:  first_name,
          middle_name: "L'Boyce",
          last_name:   last_name
        )

        expect(person).to be_valid
      end

      it "must accept \"Le'Name\"" do
        person = described_class.new(
          full_name:   full_name,
          first_name:  first_name,
          middle_name: "Le'Bryan",
          last_name:   last_name
        )

        expect(person).to be_valid
      end

      it "must accept \"La'Name\"" do
        person = described_class.new(
          full_name:   full_name,
          first_name:  first_name,
          middle_name: "La'Michal",
          last_name:   last_name
        )

        expect(person).to be_valid
      end

      it "must not allow numbers in the #middle_name" do
        person = described_class.new(
          full_name:   full_name,
          middle_name: "#{middle_name}1",
          last_name:   last_name
        )

        expect(person).to_not be_valid
        expect(person.errors[:middle_name]).to eq(
          ["must be a valid middle name"]
        )
      end
    end

    describe "middle_initial" do
      it "must accept one uppercase letter" do
        person = described_class.new(
          full_name:      full_name,
          first_name:     first_name,
          middle_initial: 'A',
          last_name:      last_name
        )

        expect(person).to be_valid
      end

      it "must not accept more than one character" do
        person = described_class.new(
          full_name:      full_name,
          first_name:     first_name,
          middle_initial: 'Aa',
          last_name:      last_name
        )

        expect(person).to_not be_valid
        expect(person.errors[:middle_initial]).to eq(
          ['must be a valid middle initial']
        )
      end

      it "must not accept lowercase letters" do
        person = described_class.new(
          full_name:      full_name,
          first_name:     first_name,
          middle_initial: 'a',
          last_name:      last_name
        )

        expect(person).to_not be_valid
        expect(person.errors[:middle_initial]).to eq(
          ['must be a valid middle initial']
        )
      end

      it "must not accept digits" do
        person = described_class.new(
          full_name:      full_name,
          first_name:     first_name,
          middle_initial: '1',
          last_name:      last_name
        )

        expect(person).to_not be_valid
        expect(person.errors[:middle_initial]).to eq(
          ['must be a valid middle initial']
        )
      end

      it "must not accept punctuation" do
        person = described_class.new(
          full_name:      full_name,
          first_name:     first_name,
          middle_initial: '-',
          last_name:      last_name
        )

        expect(person).to_not be_valid
        expect(person.errors[:middle_initial]).to eq(
          ['must be a valid middle initial']
        )
      end
    end

    describe "last_name" do
      it "must accept 'Name'" do
        person = described_class.new(
          full_name:  full_name,
          first_name: first_name,
          last_name:  last_name
        )

        expect(person).to be_valid
      end

      it "must accept 'Name-Name'" do
        person = described_class.new(
          full_name:  full_name,
          first_name: first_name,
          last_name:  "John-Johnson"
        )

        expect(person).to be_valid
      end

      it "must accept 'Name-name'" do
        person = described_class.new(
          full_name:  full_name,
          first_name: first_name,
          last_name:  "John-johnson"
        )

        expect(person).to be_valid
      end

      it "must accept \"O'Name\"" do
        person = described_class.new(
          full_name:  full_name,
          first_name: first_name,
          last_name:  "O'Brian"
        )

        expect(person).to be_valid
      end

      it "must accept \"T'Name\"" do
        person = described_class.new(
          full_name:  full_name,
          first_name: first_name,
          last_name:  "T'Quan"
        )

        expect(person).to be_valid
      end

      it "must accept \"Ta'Name\"" do
        person = described_class.new(
          full_name:  full_name,
          first_name: first_name,
          last_name:  "Ta'Quan"
        )

        expect(person).to be_valid
      end

      it "must accept \"Te'Name\"" do
        person = described_class.new(
          full_name:  full_name,
          first_name: first_name,
          last_name:  "Te'Quan"
        )

        expect(person).to be_valid
      end

      it "must accept \"K'Name\"" do
        person = described_class.new(
          full_name:  full_name,
          first_name: first_name,
          last_name:  "K'neesha"
        )

        expect(person).to be_valid
      end

      it "must accept \"D'Name\"" do
        person = described_class.new(
          full_name:  full_name,
          first_name: first_name,
          last_name:  "D'Angelo"
        )

        expect(person).to be_valid
      end

      it "must accept \"Di'Name\"" do
        person = described_class.new(
          full_name:  full_name,
          first_name: last_name,
          last_name:  "Di'Angelo"
        )

        expect(person).to be_valid
      end

      it "must accept \"L'Name\"" do
        person = described_class.new(
          full_name:  full_name,
          first_name: first_name,
          last_name:  "L'Boyce"
        )

        expect(person).to be_valid
      end

      it "must accept \"Le'Name\"" do
        person = described_class.new(
          full_name:  full_name,
          first_name: first_name,
          last_name:  "Le'Bryan"
        )

        expect(person).to be_valid
      end

      it "must accept \"La'Name\"" do
        person = described_class.new(
          full_name:  full_name,
          first_name: first_name,
          last_name:  "La'Michal"
        )

        expect(person).to be_valid
      end

      it "must not allow numbers in the #last_name" do
        person = described_class.new(
          full_name:   full_name,
          middle_name: middle_name,
          last_name:   "#{last_name}1"
        )

        expect(person).to_not be_valid
        expect(person.errors[:last_name]).to eq(
          ["must be a valid last name"]
        )
      end
    end

    describe "suffix" do
      %w[Jr Sr II III IV V Esq CPA Dc Dds Vm Jd Md Phd].each do |suffix|
        it "must accept '#{suffix}'" do
          person = described_class.new(
            full_name:  "#{full_name}, #{suffix}",
            first_name: first_name,
            last_name:  last_name,
            suffix:     suffix
          )

          expect(person).to be_valid
        end
      end

      it "must not allow unknown suffixes" do
        person = described_class.new(
          full_name:  full_name,
          first_name: first_name,
          last_name:  last_name,
          suffix:     'xXx'
        )

        expect(person).to_not be_valid
        expect(person.errors[:suffix]).to eq(
          ["is not included in the list"]
        )
      end
    end
  end

  describe ".lookup" do
    before do
      described_class.create(
        full_name:  "Bob #{last_name}",
        first_name: 'Bob',
        last_name:  last_name
      )

      described_class.create(
        full_name:  full_name,
        first_name: first_name,
        last_name:  last_name
      )

      described_class.create(
        full_name: "Alice #{last_name}",
        first_name: 'Alice',
        last_name:  last_name
      )
    end

    it "must query the #{described_class} with the matching #full_name" do
      person = described_class.lookup(full_name)

      expect(person).to be_kind_of(described_class)
      expect(person.id).to_not be(nil)
      expect(person.full_name).to eq(full_name)
    end

    after { described_class.destroy_all }
  end

  describe ".parse" do
    subject { described_class.parse(full_name) }

    context "when given a single first-name" do
      let(:full_name) { first_name }

      it "must return the full_name: and first_name: attributes" do
        expect(subject).to eq(
          {
            full_name:  first_name,

            prefix:         nil,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: nil,
            last_name:      nil,
            suffix:         nil
          }
        )
      end
    end

    context "when given 'first-name last-name'" do
      let(:full_name) { "#{first_name} #{last_name}" }

      it "must return the full_name:, first_name:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:  full_name,

            prefix:         nil,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: nil,
            last_name:      last_name,
            suffix:         nil
          }
        )
      end
    end

    context "when given 'first-name middle-initial last-name'" do
      let(:full_name) { "#{first_name} #{middle_initial} #{last_name}" }

      it "must return the full_name:, first_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         nil,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         nil
          }
        )
      end
    end

    context "when given 'first-name middle-initial. last-name'" do
      let(:full_name) { "#{first_name} #{middle_initial}. #{last_name}" }

      it "must return the full_name:, first_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         nil,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         nil
          }
        )
      end
    end

    context "when given 'first-name middle-name last-name'" do
      let(:full_name) { "#{first_name} #{middle_name} #{last_name}" }

      it "must return the full_name:, first_name:, middle_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         nil,
            first_name:     first_name,
            middle_name:    middle_name,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         nil
          }
        )
      end
    end

    context "when given 'prefix first-name'" do
      let(:full_name) { "#{prefix} #{first_name}" }

      it "must return the full_name:, prefix:, and first_name: attributes" do
        expect(subject).to eq(
          {
            full_name:  full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: nil,
            last_name:      nil,
            suffix:         nil
          }
        )
      end
    end

    context "when given 'prefix first-name last-name'" do
      let(:full_name) { "#{prefix} #{first_name} #{last_name}" }

      it "must return the full_name:, first_name:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:  full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: nil,
            last_name:      last_name,
            suffix:         nil
          }
        )
      end
    end

    context "when given 'prefix first-name middle-initial last-name'" do
      let(:full_name) { "#{prefix} #{first_name} #{middle_initial} #{last_name}" }

      it "must return the full_name:, prefix:, first_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         nil
          }
        )
      end
    end

    context "when given 'prefix first-name middle-initial. last-name'" do
      let(:full_name) { "#{prefix} #{first_name} #{middle_initial}. #{last_name}" }

      it "must return the full_name:, prefix:, first_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         nil
          }
        )
      end
    end

    context "when given 'prefix first-name middle-name last-name'" do
      let(:full_name) { "#{prefix} #{first_name} #{middle_name} #{last_name}" }

      it "must return the full_name:, prefix:, first_name:, middle_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    middle_name,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         nil
          }
        )
      end
    end

    context "when given 'prefix. first-name'" do
      let(:full_name) { "#{prefix}. #{first_name}" }

      it "must return the full_name:, prefix:, and first_name: attributes" do
        expect(subject).to eq(
          {
            full_name:  full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: nil,
            last_name:      nil,
            suffix:         nil
          }
        )
      end
    end

    context "when given 'prefix. first-name last-name'" do
      let(:full_name) { "#{prefix}. #{first_name} #{last_name}" }

      it "must return the full_name:, first_name:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:  full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: nil,
            last_name:      last_name,
            suffix:         nil
          }
        )
      end
    end

    context "when given 'prefix. first-name middle-initial last-name'" do
      let(:full_name) { "#{prefix}. #{first_name} #{middle_initial} #{last_name}" }

      it "must return the full_name:, prefix:, first_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         nil
          }
        )
      end
    end

    context "when given 'prefix. first-name middle-initial. last-name'" do
      let(:full_name) { "#{prefix}. #{first_name} #{middle_initial}. #{last_name}" }

      it "must return the full_name:, prefix:, first_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         nil
          }
        )
      end
    end

    context "when given 'prefix. first-name middle-name last-name'" do
      let(:full_name) { "#{prefix}. #{first_name} #{middle_name} #{last_name}" }

      it "must return the full_name:, prefix:, first_name:, middle_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    middle_name,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         nil
          }
        )
      end
    end

    context "when given 'first-name last-name suffix'" do
      let(:full_name) { "#{first_name} #{last_name} #{suffix}" }

      it "must return the full_name:, first_name:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:  full_name,

            prefix:         nil,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: nil,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'first-name middle-initial last-name suffix'" do
      let(:full_name) { "#{first_name} #{middle_initial} #{last_name} #{suffix}" }

      it "must return the full_name:, prefix:, first_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         nil,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'first-name middle-initial. last-name suffix'" do
      let(:full_name) { "#{first_name} #{middle_initial}. #{last_name} #{suffix}" }

      it "must return the full_name:, prefix:, first_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         nil,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'first-name middle-name last-name suffix'" do
      let(:full_name) { "#{first_name} #{middle_name} #{last_name} #{suffix}" }

      it "must return the full_name:, prefix:, first_name:, middle_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         nil,
            first_name:     first_name,
            middle_name:    middle_name,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'first-name last-name suffix.'" do
      let(:full_name) { "#{first_name} #{last_name} #{suffix}." }

      it "must return the full_name:, first_name:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:  full_name,

            prefix:         nil,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: nil,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'first-name middle-initial last-name suffix.'" do
      let(:full_name) { "#{first_name} #{middle_initial} #{last_name} #{suffix}." }

      it "must return the full_name:, prefix:, first_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         nil,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'first-name middle-initial. last-name suffix.'" do
      let(:full_name) { "#{first_name} #{middle_initial}. #{last_name} #{suffix}." }

      it "must return the full_name:, prefix:, first_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         nil,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'first-name middle-name last-name suffix.'" do
      let(:full_name) { "#{first_name} #{middle_name} #{last_name} #{suffix}." }

      it "must return the full_name:, prefix:, first_name:, middle_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         nil,
            first_name:     first_name,
            middle_name:    middle_name,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'first-name last-name, suffix'" do
      let(:full_name) { "#{first_name} #{last_name}, #{suffix}" }

      it "must return the full_name:, first_name:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:  full_name,

            prefix:         nil,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: nil,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'first-name middle-initial last-name, suffix'" do
      let(:full_name) { "#{first_name} #{middle_initial} #{last_name}, #{suffix}" }

      it "must return the full_name:, prefix:, first_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         nil,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'first-name middle-initial. last-name, suffix'" do
      let(:full_name) { "#{first_name} #{middle_initial}. #{last_name}, #{suffix}" }

      it "must return the full_name:, prefix:, first_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         nil,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'first-name middle-name last-name, suffix'" do
      let(:full_name) { "#{first_name} #{middle_name} #{last_name}, #{suffix}" }

      it "must return the full_name:, prefix:, first_name:, middle_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         nil,
            first_name:     first_name,
            middle_name:    middle_name,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'first-name last-name, suffix.'" do
      let(:full_name) { "#{first_name} #{last_name}, #{suffix}." }

      it "must return the full_name:, first_name:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:  full_name,

            prefix:         nil,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: nil,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'first-name middle-initial last-name, suffix.'" do
      let(:full_name) { "#{first_name} #{middle_initial} #{last_name}, #{suffix}." }

      it "must return the full_name:, prefix:, first_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         nil,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'first-name middle-initial. last-name, suffix.'" do
      let(:full_name) { "#{first_name} #{middle_initial}. #{last_name}, #{suffix}." }

      it "must return the full_name:, prefix:, first_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         nil,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'first-name middle-name last-name, suffix.'" do
      let(:full_name) { "#{first_name} #{middle_name} #{last_name}, #{suffix}." }

      it "must return the full_name:, prefix:, first_name:, middle_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         nil,
            first_name:     first_name,
            middle_name:    middle_name,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'prefix first-name last-name suffix'" do
      let(:full_name) { "#{prefix} #{first_name} #{last_name} #{suffix}" }

      it "must return the full_name:, first_name:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:  full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: nil,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'prefix first-name middle-initial last-name suffix'" do
      let(:full_name) { "#{prefix} #{first_name} #{middle_initial} #{last_name} #{suffix}" }

      it "must return the full_name:, prefix:, first_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'prefix first-name middle-initial. last-name suffix'" do
      let(:full_name) { "#{prefix} #{first_name} #{middle_initial}. #{last_name} #{suffix}" }

      it "must return the full_name:, prefix:, first_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'prefix first-name middle-name last-name suffix'" do
      let(:full_name) { "#{prefix} #{first_name} #{middle_name} #{last_name} #{suffix}" }

      it "must return the full_name:, prefix:, first_name:, middle_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    middle_name,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'prefix. first-name last-name suffix'" do
      let(:full_name) { "#{prefix}. #{first_name} #{last_name} #{suffix}" }

      it "must return the full_name:, first_name:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:  full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: nil,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'prefix. first-name middle-initial last-name suffix'" do
      let(:full_name) { "#{prefix}. #{first_name} #{middle_initial} #{last_name} #{suffix}" }

      it "must return the full_name:, prefix:, first_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'prefix. first-name middle-initial. last-name suffix'" do
      let(:full_name) { "#{prefix}. #{first_name} #{middle_initial}. #{last_name} #{suffix}" }

      it "must return the full_name:, prefix:, first_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'prefix. first-name middle-name last-name suffix'" do
      let(:full_name) { "#{prefix}. #{first_name} #{middle_name} #{last_name} #{suffix}" }

      it "must return the full_name:, prefix:, first_name:, middle_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    middle_name,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'prefix first-name last-name suffix.'" do
      let(:full_name) { "#{prefix} #{first_name} #{last_name} #{suffix}." }

      it "must return the full_name:, first_name:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:  full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: nil,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'prefix first-name middle-initial last-name suffix.'" do
      let(:full_name) { "#{prefix} #{first_name} #{middle_initial} #{last_name} #{suffix}." }

      it "must return the full_name:, prefix:, first_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'prefix first-name middle-initial. last-name suffix.'" do
      let(:full_name) { "#{prefix} #{first_name} #{middle_initial}. #{last_name} #{suffix}." }

      it "must return the full_name:, prefix:, first_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'prefix first-name middle-name last-name suffix.'" do
      let(:full_name) { "#{prefix} #{first_name} #{middle_name} #{last_name} #{suffix}." }

      it "must return the full_name:, prefix:, first_name:, middle_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    middle_name,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'prefix. first-name last-name suffix.'" do
      let(:full_name) { "#{prefix}. #{first_name} #{last_name} #{suffix}." }

      it "must return the full_name:, first_name:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:  full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: nil,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'prefix. first-name middle-initial last-name suffix.'" do
      let(:full_name) { "#{prefix}. #{first_name} #{middle_initial} #{last_name} #{suffix}." }

      it "must return the full_name:, prefix:, first_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'prefix. first-name middle-initial. last-name suffix.'" do
      let(:full_name) { "#{prefix}. #{first_name} #{middle_initial}. #{last_name} #{suffix}." }

      it "must return the full_name:, prefix:, first_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'prefix. first-name middle-name last-name suffix.'" do
      let(:full_name) { "#{prefix}. #{first_name} #{middle_name} #{last_name} #{suffix}." }

      it "must return the full_name:, prefix:, first_name:, middle_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    middle_name,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'prefix first-name last-name, suffix'" do
      let(:full_name) { "#{prefix} #{first_name} #{last_name}, #{suffix}" }

      it "must return the full_name:, first_name:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:  full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: nil,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'prefix first-name middle-initial last-name, suffix'" do
      let(:full_name) { "#{prefix} #{first_name} #{middle_initial} #{last_name}, #{suffix}" }

      it "must return the full_name:, prefix:, first_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'prefix first-name middle-initial. last-name, suffix'" do
      let(:full_name) { "#{prefix} #{first_name} #{middle_initial}. #{last_name}, #{suffix}" }

      it "must return the full_name:, prefix:, first_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'prefix first-name middle-name last-name, suffix'" do
      let(:full_name) { "#{prefix} #{first_name} #{middle_name} #{last_name}, #{suffix}" }

      it "must return the full_name:, prefix:, first_name:, middle_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    middle_name,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'prefix. first-name last-name, suffix'" do
      let(:full_name) { "#{prefix}. #{first_name} #{last_name}, #{suffix}" }

      it "must return the full_name:, first_name:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:  full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: nil,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'prefix. first-name middle-initial last-name, suffix'" do
      let(:full_name) { "#{prefix}. #{first_name} #{middle_initial} #{last_name}, #{suffix}" }

      it "must return the full_name:, prefix:, first_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'prefix. first-name middle-initial. last-name, suffix'" do
      let(:full_name) { "#{prefix}. #{first_name} #{middle_initial}. #{last_name}, #{suffix}" }

      it "must return the full_name:, prefix:, first_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'prefix. first-name middle-name last-name, suffix'" do
      let(:full_name) { "#{prefix}. #{first_name} #{middle_name} #{last_name}, #{suffix}" }

      it "must return the full_name:, prefix:, first_name:, middle_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    middle_name,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'prefix first-name last-name, suffix.'" do
      let(:full_name) { "#{prefix} #{first_name} #{last_name}, #{suffix}." }

      it "must return the full_name:, first_name:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:  full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: nil,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'prefix first-name middle-initial last-name, suffix.'" do
      let(:full_name) { "#{prefix} #{first_name} #{middle_initial} #{last_name}, #{suffix}." }

      it "must return the full_name:, prefix:, first_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'prefix first-name middle-initial. last-name, suffix.'" do
      let(:full_name) { "#{prefix} #{first_name} #{middle_initial}. #{last_name}, #{suffix}." }

      it "must return the full_name:, prefix:, first_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'prefix first-name middle-name last-name, suffix.'" do
      let(:full_name) { "#{prefix} #{first_name} #{middle_name} #{last_name}, #{suffix}." }

      it "must return the full_name:, prefix:, first_name:, middle_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    middle_name,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'prefix. first-name last-name, suffix.'" do
      let(:full_name) { "#{prefix}. #{first_name} #{last_name}, #{suffix}." }

      it "must return the full_name:, first_name:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:  full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: nil,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'prefix. first-name middle-initial last-name, suffix.'" do
      let(:full_name) { "#{prefix}. #{first_name} #{middle_initial} #{last_name}, #{suffix}." }

      it "must return the full_name:, prefix:, first_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'prefix. first-name middle-initial. last-name, suffix.'" do
      let(:full_name) { "#{prefix}. #{first_name} #{middle_initial}. #{last_name}, #{suffix}." }

      it "must return the full_name:, prefix:, first_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    nil,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given 'prefix. first-name middle-name last-name, suffix.'" do
      let(:full_name) { "#{prefix}. #{first_name} #{middle_name} #{last_name}, #{suffix}." }

      it "must return the full_name:, prefix:, first_name:, middle_name:, middle_initial:, and last_name: attributes" do
        expect(subject).to eq(
          {
            full_name:      full_name,

            prefix:         prefix,
            first_name:     first_name,
            middle_name:    middle_name,
            middle_initial: middle_initial,
            last_name:      last_name,
            suffix:         suffix
          }
        )
      end
    end

    context "when given a non-name String" do
      let(:name) { "not_a_name" }

      it do
        expect {
          described_class.parse(name)
        }.to raise_error(ArgumentError,"invalid personal name: #{name.inspect}")
      end
    end
  end

  describe ".import" do
    let(:full_name) { "#{prefix}. #{first_name} #{middle_name} #{last_name}, #{suffix}." }

    subject { described_class.import(full_name) }

    it "must parse and create a new #{described_class} from the given name" do
      expect(subject).to be_kind_of(described_class)
      expect(subject.id).to_not be(nil)
      expect(subject.full_name).to eq(full_name)
      expect(subject.prefix).to eq(prefix)
      expect(subject.first_name).to eq(first_name)
      expect(subject.middle_name).to eq(middle_name)
      expect(subject.middle_initial).to eq(middle_initial)
      expect(subject.last_name).to eq(last_name)
      expect(subject.suffix).to eq(suffix)
    end

    after { described_class.destroy_all }

    context "when given a non-name String" do
      let(:name) { "not_a_name" }

      it do
        expect {
          described_class.import(name)
        }.to raise_error(ArgumentError,"invalid personal name: #{name.inspect}")
      end
    end
  end

  shared_examples_for "people with street addresses" do
    let(:first_name1) { "Bob" }
    let(:last_name1)  { "Smith" }
    let(:full_name1)  { "#{first_name1} #{last_name1}" }

    let(:first_name2) { "Alice" }
    let(:last_name2)  { "Smith" }
    let(:full_name2)  { "#{first_name2} #{last_name2}" }

    let(:address1) { '123 First St.' }
    let(:city1)    { 'City One' }
    let(:state1)   { 'State One' }
    let(:zipcode1) { '1234' }
    let(:country1) { 'USA' }

    let(:address2) { '123 Second St.' }
    let(:city2)    { 'City Two' }
    let(:state2)   { 'State Two' }
    let(:zipcode2) { '4567' }
    let(:country2) { 'USB' }

    before do
      person1 = described_class.create(
        full_name:  "John Smith",
        first_name: 'John',
        last_name:  'Smith'
      )

      person2 = described_class.create(
        full_name:  full_name1,
        first_name: first_name1,
        last_name:  last_name1
      )

      person3 = described_class.create(
        full_name:  full_name2,
        first_name: first_name2,
        last_name:  last_name2
      )

      person4 = described_class.create(
        full_name:  "Eve Smith",
        first_name: 'Eve',
        last_name:  'Smith'
      )

      street_address1 = Ronin::DB::StreetAddress.create(
        address: address1,
        city:    city1,
        state:   state1,
        zipcode: zipcode1,
        country: country1
      )

      street_address2 = Ronin::DB::StreetAddress.create(
        address: address2,
        city:    city2,
        state:   state2,
        zipcode: zipcode2,
        country: country2
      )

      Ronin::DB::PersonalStreetAddress.create(
        person:         person1,
        street_address: street_address2
      )

      Ronin::DB::PersonalStreetAddress.create(
        person:         person2,
        street_address: street_address1
      )

      Ronin::DB::PersonalStreetAddress.create(
        person:         person3,
        street_address: street_address1
      )

      Ronin::DB::PersonalStreetAddress.create(
        person:         person4,
        street_address: street_address2
      )
    end

    after do
      Ronin::DB::PersonalStreetAddress.destroy_all
      Ronin::DB::StreetAddress.destroy_all
      described_class.destroy_all
    end
  end

  describe ".for_address" do
    subject { described_class }

    include_context "people with street addresses"

    it "must find all #{described_class} associated with the street address" do
      people = subject.for_address(address1)

      expect(people.length).to eq(2)

      expect(people[0].full_name).to eq(full_name1)
      expect(people[0].first_name).to eq(first_name1)
      expect(people[0].last_name).to eq(last_name1)

      expect(people[1].full_name).to eq(full_name2)
      expect(people[1].first_name).to eq(first_name2)
      expect(people[1].last_name).to eq(last_name2)
    end
  end

  describe ".for_city" do
    subject { described_class }

    include_context "people with street addresses"

    it "must find all #{described_class} associated with the city" do
      people = subject.for_city(city1)

      expect(people.length).to eq(2)

      expect(people[0].full_name).to eq(full_name1)
      expect(people[0].first_name).to eq(first_name1)
      expect(people[0].last_name).to eq(last_name1)

      expect(people[1].full_name).to eq(full_name2)
      expect(people[1].first_name).to eq(first_name2)
      expect(people[1].last_name).to eq(last_name2)
    end
  end

  describe ".for_state" do
    subject { described_class }

    include_context "people with street addresses"

    it "must find all #{described_class} associated with the state" do
      people = subject.for_state(state1)

      expect(people.length).to eq(2)

      expect(people[0].full_name).to eq(full_name1)
      expect(people[0].first_name).to eq(first_name1)
      expect(people[0].last_name).to eq(last_name1)

      expect(people[1].full_name).to eq(full_name2)
      expect(people[1].first_name).to eq(first_name2)
      expect(people[1].last_name).to eq(last_name2)
    end
  end

  describe ".for_province" do
    subject { described_class }

    include_context "people with street addresses"

    it "must find all #{described_class} associated with the province" do
      people = subject.for_province(state1)

      expect(people.length).to eq(2)

      expect(people[0].full_name).to eq(full_name1)
      expect(people[0].first_name).to eq(first_name1)
      expect(people[0].last_name).to eq(last_name1)

      expect(people[1].full_name).to eq(full_name2)
      expect(people[1].first_name).to eq(first_name2)
      expect(people[1].last_name).to eq(last_name2)
    end
  end

  describe ".for_zipcode" do
    subject { described_class }

    include_context "people with street addresses"

    it "must find all #{described_class} associated with the zipcode" do
      people = subject.for_zipcode(zipcode1)

      expect(people.length).to eq(2)

      expect(people[0].full_name).to eq(full_name1)
      expect(people[0].first_name).to eq(first_name1)
      expect(people[0].last_name).to eq(last_name1)

      expect(people[1].full_name).to eq(full_name2)
      expect(people[1].first_name).to eq(first_name2)
      expect(people[1].last_name).to eq(last_name2)
    end
  end

  describe ".for_country" do
    subject { described_class }

    include_context "people with street addresses"

    it "must find all #{described_class} associated with the country" do
      people = subject.for_country(country1)

      expect(people.length).to eq(2)

      expect(people[0].full_name).to eq(full_name1)
      expect(people[0].first_name).to eq(first_name1)
      expect(people[0].last_name).to eq(last_name1)

      expect(people[1].full_name).to eq(full_name2)
      expect(people[1].first_name).to eq(first_name2)
      expect(people[1].last_name).to eq(last_name2)
    end
  end

  describe ".with_prefix" do
    subject { described_class }

    before do
      described_class.create(
        full_name:  "#{prefix} John Smith",
        prefix:     prefix,
        first_name: 'John',
        last_name:  'Smith'
      )

      described_class.create(
        full_name:  "Alice Smith",
        first_name: 'Alice',
        last_name:  'Smith'
      )

      described_class.create(
        full_name:  "Dr. Eve Smith",
        prefix:     'Dr',
        first_name: 'Eve',
        last_name:  'Smith'
      )

      described_class.create(
        full_name:  "#{prefix} Bob Smith",
        prefix:     prefix,
        first_name: 'Bob',
        last_name:  'Smith'
      )
    end

    it "must find all #{described_class} with the matching #prefix" do
      people = subject.with_prefix(prefix)

      expect(people).to_not be_empty
      expect(people).to all(be_kind_of(described_class))
      expect(people.map(&:prefix).uniq).to eq([prefix])
    end

    after { described_class.destroy_all }
  end

  describe ".with_first_name" do
    subject { described_class }

    before do
      described_class.create(
        full_name:  "#{first_name} Smith",
        first_name: first_name,
        last_name:  'Smith'
      )

      described_class.create(
        full_name:  "Alice Alison",
        first_name: 'Alice',
        last_name:  'Smith'
      )

      described_class.create(
        full_name:  "#{first_name} Smith",
        first_name: first_name,
        last_name:  'Smith'
      )

      described_class.create(
        full_name:  "Bob Smith",
        first_name: 'Bob',
        last_name:  'Smith'
      )
    end

    it "must find all #{described_class} with the matching #first_name" do
      people = subject.with_first_name(first_name)

      expect(people).to_not be_empty
      expect(people).to all(be_kind_of(described_class))
      expect(people.map(&:first_name).uniq).to eq([first_name])
    end

    after { described_class.destroy_all }
  end

  describe ".with_middle_name" do
    subject { described_class }

    before do
      described_class.create(
        full_name:      "John #{middle_name} Smith",
        first_name:     'John',
        middle_name:    middle_name,
        middle_initial: middle_initial,
        last_name:      'Smith'
      )

      described_class.create(
        full_name:      "Alice Argyle Alison",
        first_name:     'Alice',
        middle_name:    'Argyle',
        middle_initial: 'A',
        last_name:      'Alison'
      )

      described_class.create(
        full_name:      "Bob #{middle_name} Robertson",
        first_name:     'Bob',
        middle_name:    middle_name,
        middle_initial: middle_initial,
        last_name:      'Robertson'
      )

      described_class.create(
        full_name:      "Eve Evil Everson",
        first_name:     'Eve',
        middle_name:    'Evil',
        middle_initial: 'E',
        last_name:      'Everson'
      )
    end

    it "must find all #{described_class} with the matching #middle_name" do
      people = subject.with_middle_name(middle_name)

      expect(people).to_not be_empty
      expect(people).to all(be_kind_of(described_class))
      expect(people.map(&:middle_name).uniq).to eq([middle_name])
    end

    after { described_class.destroy_all }
  end

  describe ".with_middle_initial" do
    subject { described_class }

    before do
      described_class.create(
        full_name:      "John #{middle_name} Smith",
        first_name:     'John',
        middle_name:    middle_name,
        middle_initial: middle_initial,
        last_name:      'Smith'
      )

      described_class.create(
        full_name:      "Alice Argyle Alison",
        first_name:     'Alice',
        middle_name:    'Argyle',
        middle_initial: 'A',
        last_name:      'Alison'
      )

      described_class.create(
        full_name:      "Bob #{middle_name} Robertson",
        first_name:     'Bob',
        middle_name:    middle_name,
        middle_initial: middle_initial,
        last_name:      'Robertson'
      )

      described_class.create(
        full_name:      "Eve Evil Everson",
        first_name:     'Eve',
        middle_name:    'Evil',
        middle_initial: 'E',
        last_name:      'Everson'
      )
    end

    it "must find all #{described_class} with the matching #middle_initial" do
      people = subject.with_middle_initial(middle_initial)

      expect(people).to_not be_empty
      expect(people).to all(be_kind_of(described_class))
      expect(people.map(&:middle_initial).uniq).to eq([middle_initial])
    end

    after { described_class.destroy_all }
  end

  describe ".with_last_name" do
    subject { described_class }

    before do
      described_class.create(
        full_name:  "John #{last_name}",
        first_name: 'John',
        last_name:  last_name
      )

      described_class.create(
        full_name:  "Alice Alison",
        first_name: 'Alice',
        last_name:  'Alison'
      )

      described_class.create(
        full_name:  "Bob #{last_name}",
        first_name: 'Bob',
        last_name:  last_name
      )

      described_class.create(
        full_name:  "Eve Everson",
        first_name: 'Eve',
        last_name:  'Everson'
      )
    end

    it "must find all #{described_class} with the matching #first_name" do
      people = subject.with_last_name(last_name)

      expect(people).to_not be_empty
      expect(people).to all(be_kind_of(described_class))
      expect(people.map(&:last_name).uniq).to eq([last_name])
    end

    after { described_class.destroy_all }
  end

  describe ".with_suffix" do
    subject { described_class }

    before do
      described_class.create(
        full_name:  "John Smith, #{suffix}",
        first_name: 'John',
        last_name:  'Smith',
        suffix:     suffix
      )

      described_class.create(
        full_name:  "Alice Smith",
        first_name: 'Bob',
        last_name:  'Smith'
      )

      described_class.create(
        full_name:  "Eve Smith, PhD.",
        prefix:     'PhD',
        first_name: 'Bob',
        last_name:  'Smith'
      )

      described_class.create(
        full_name:  "Bob Smith, #{suffix}.",
        first_name: 'Bob',
        last_name:  'Smith',
        suffix:     suffix
      )
    end

    it "must find all #{described_class} with the matching #suffix" do
      people = subject.with_suffix(suffix)

      expect(people).to_not be_empty
      expect(people).to all(be_kind_of(described_class))
      expect(people.map(&:suffix).uniq).to eq([suffix])
    end

    after { described_class.destroy_all }
  end

  subject do
    described_class.new(
      full_name:  full_name,
      first_name: first_name,
      last_name:  last_name
    )
  end

  describe "#to_s" do
    it "must return the #full_name" do
      expect(subject.to_s).to eq(full_name)
    end
  end
end
