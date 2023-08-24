require 'spec_helper'
require 'ronin/db/user_name'

describe Ronin::DB::UserName do
  it "must use the 'ronin_user_names' table" do
    expect(described_class.table_name).to eq('ronin_user_names')
  end

  it "must include Ronin::DB::Model::HasUniqueName" do
    expect(described_class).to include(Ronin::DB::Model::HasUniqueName)
  end

  let(:name) { 'jsmith' }

  subject { described_class.new(name: name) }

  describe "validations" do
    it "should require a name" do
      user = described_class.new
      expect(user).not_to be_valid

      user = described_class.new(name: name)
      expect(user).to be_valid
    end
  end

  describe ".with_password" do
    let(:plain_text) { 'secret' }

    before do
      user_name = Ronin::DB::UserName.create(name: name)
      password  = Ronin::DB::Password.create(plain_text: plain_text)

      Ronin::DB::Credential.create(
        user_name: user_name,
        password:  password
      )
    end

    subject { described_class }

    it "must query all #{described_class} that are associated with the password" do
      user_name = subject.with_password(plain_text).first

      expect(user_name).to be_kind_of(described_class)
      expect(user_name.passwords.map(&:plain_text)).to eq([plain_text])
    end

    after do
      Ronin::DB::Credential.destroy_all
      Ronin::DB::Password.destroy_all
      Ronin::DB::UserName.destroy_all
    end
  end

  describe ".lookup" do
    before do
      described_class.create(name: 'other1')
      described_class.create(name: name)
      described_class.create(name: 'other2')
    end

    it "must query the #{described_class} with the matching name" do
      user_name = described_class.lookup(name)

      expect(user_name).to be_kind_of(described_class)
      expect(user_name.name).to eq(name)
    end

    after { described_class.destroy_all }
  end

  describe ".import" do
    subject { described_class.import(name) }

    it "must import the #{described_class} for the user name" do
      expect(subject).to be_kind_of(described_class)
      expect(subject.name).to eq(name)
    end

    after { subject.destroy }
  end
end
