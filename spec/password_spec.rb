require 'spec_helper'
require 'ronin/db/password'

describe Ronin::DB::Password do
  it "must use the 'ronin_passwords' table" do
    expect(described_class.table_name).to eq('ronin_passwords')
  end

  let(:plain_text) { 'secret' }

  subject { described_class.new(plain_text: plain_text) }

  describe "validations" do
    it "should require a clear-text password" do
      pass = described_class.new
      expect(pass).not_to be_valid

      pass.plain_text = plain_text
      expect(pass).to be_valid
    end
  end

  describe ".lookup" do
    before do
      described_class.create(plain_text: 'other_password1')
      described_class.create(plain_text: plain_text)
      described_class.create(plain_text: 'other_pasword2')
    end

    it "must query the #{described_class} with the matching plain text password" do
      password = described_class.lookup(plain_text)

      expect(password).to be_kind_of(described_class)
      expect(password.plain_text).to eq(plain_text)
    end

    after { described_class.destroy_all }
  end

  describe ".import" do
    subject { described_class.import(plain_text) }

    it "must import the given password" do
      expect(subject.id).to_not be(nil)
      expect(subject.plain_text).to eq(plain_text)
    end

    after { described_class.destroy_all }
  end

  describe "#digest" do
    let(:salt) { 'foo' }

    it "should calculate the digest of the password" do
      digest = subject.digest(:sha1)
      
      expect(digest).to eq(Digest::SHA1.hexdigest(plain_text))
    end

    it "should calculate the digest of the password and prepended salt" do
      digest = subject.digest(:sha1, prepend_salt: salt)
      
      expect(digest).to eq(Digest::SHA1.hexdigest(salt + plain_text))
    end

    it "should calculate the digest of the password and appended salt" do
      digest = subject.digest(:sha1, append_salt: salt)
      
      expect(digest).to eq(Digest::SHA1.hexdigest(plain_text + salt))
    end
  end

  describe "#count" do
  end

  describe "#to_s" do
    it "should return the plain text password" do
      expect(subject.to_s).to eq(plain_text)
    end
  end
end
