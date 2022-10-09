require 'spec_helper'
require 'ronin/db/credential'

describe Ronin::DB::Credential do
  it "must use the 'ronin_credentials' table" do
    expect(described_class.table_name).to eq('ronin_credentials')
  end

  let(:name)       { 'alice'  }
  let(:plain_text) { 'secret' }

  describe "validations" do
    describe "user_name" do
      context "when email_address is nil" do
        it "must require a user_name" do
          credential = described_class.new(
            password: Ronin::DB::Password.new(plain_text: plain_text)
          )
          expect(credential).to_not be_valid
          expect(credential.errors[:user_name]).to eq(
            ["can't be blank"]
          )
        end
      end

      context "when email_address is not nil" do
        it "must allow user_name to be nil" do
          credential = described_class.new(
            password:      Ronin::DB::Password.new(plain_text: plain_text),
            email_address: Ronin::DB::EmailAddress.new(
              address:   'john.smith@example.com',
              user_name: Ronin::DB::UserName.new(name: 'john.smith'),
              host_name: Ronin::DB::HostName.new(name: 'example.com')
            )
          )
          expect(credential).to be_valid
        end
      end
    end

    describe "email_address" do
      context "when user_name is nil" do
        it "must require an email_address" do
          credential = described_class.new(
            password: Ronin::DB::Password.new(plain_text: plain_text)
          )
          expect(credential).to_not be_valid
          expect(credential.errors[:email_address]).to eq(
            ["can't be blank"]
          )
        end
      end

      context "when user_name is not nil" do
        it "must allow email_address to be nil" do
          credential = described_class.new(
            password:  Ronin::DB::Password.new(plain_text: plain_text),
            user_name: Ronin::DB::UserName.new(name: 'admin')
          )
          expect(credential).to be_valid
        end
      end
    end

    describe "password" do
      it "must require a password" do
        credential = described_class.new(
          user_name: Ronin::DB::UserName.new(name: name)
        )
        expect(credential).to_not be_valid
        expect(credential.errors[:password]).to eq(
          ["must exist"]
        )
      end
    end
  end

  describe ".for_user" do
    before do
      user_name = Ronin::DB::UserName.create(name: name)
      password  = Ronin::DB::Password.create(plain_text: plain_text)

      described_class.create(
        user_name: user_name,
        password:  password
      )
    end

    subject { described_class }

    it "must query all #{described_class} with the matching user name" do
      credential = subject.for_user(name).first

      expect(credential).to be_kind_of(described_class)
      expect(credential.user_name.name).to eq(name)
    end

    after do
      Ronin::DB::Credential.destroy_all
      Ronin::DB::Password.destroy_all
      Ronin::DB::UserName.destroy_all
    end
  end

  describe ".with_email_address" do
    let(:user)   { 'john.smith'  }
    let(:domain) { 'example.com' }
    let(:email)  { "#{user}@#{domain}" }

    before do
      user_name     = Ronin::DB::UserName.create(name: user)
      host_name     = Ronin::DB::HostName.create(name: domain)
      email_address = Ronin::DB::EmailAddress.create(
        address:   email,
        user_name: user_name,
        host_name: host_name
      )

      password  = Ronin::DB::Password.create(plain_text: plain_text)

      credential = described_class.create(
        email_address: email_address,
        password:      password
      )
    end

    subject { described_class }

    it "must query all #{described_class} with the matching email address" do
      credential = subject.with_email_address(email).first

      expect(credential).to be_kind_of(described_class)
      expect(credential.email_address.user_name.name).to eq(user)
      expect(credential.email_address.host_name.name).to eq(domain)
   end

    after do
      Ronin::DB::Credential.destroy_all
      Ronin::DB::Password.destroy_all
      Ronin::DB::EmailAddress.destroy_all
      Ronin::DB::UserName.destroy_all
      Ronin::DB::HostName.destroy_all
    end
  end

  describe ".with_password" do
    before do
      user_name = Ronin::DB::UserName.create(name: name)
      password  = Ronin::DB::Password.create(plain_text: plain_text)

      described_class.create(
        user_name: user_name,
        password:  password
      )
    end

    subject { described_class }

    it "must query all #{described_class} with the matching password" do
      credential = subject.with_password(plain_text).first

      expect(credential).to be_kind_of(described_class)
      expect(credential.password.plain_text).to eq(plain_text)
    end

    after do
      Ronin::DB::Credential.destroy_all
      Ronin::DB::Password.destroy_all
      Ronin::DB::UserName.destroy_all
    end
  end

  subject do
    described_class.new(
      user_name: Ronin::DB::UserName.new(name: name),
      password:  Ronin::DB::Password.new(plain_text: plain_text)
    )
  end

  describe "#user" do
    it "must return the username String" do
      expect(subject.user).to eq(name)
    end
  end

  describe "#plain_text" do
    it "should provide the clear-text password String" do
      expect(subject.plain_text).to eq(plain_text)
    end
  end

  describe "#to_s" do
    it "should include the user name and password" do
      expect(subject.to_s).to eq("#{name}:#{plain_text}")
    end
  end
end
