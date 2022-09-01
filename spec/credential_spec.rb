require 'spec_helper'
require 'ronin/db/credential'

describe Ronin::DB::Credential do
  it "must use the 'ronin_credentials' table" do
    expect(described_class.table_name).to eq('ronin_credentials')
  end

  let(:name)       { 'alice'  }
  let(:clear_text) { 'secret' }

  describe "validations" do
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
      password  = Ronin::DB::Password.create(clear_text: clear_text)

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

      password  = Ronin::DB::Password.create(clear_text: clear_text)

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
      password  = Ronin::DB::Password.create(clear_text: clear_text)

      described_class.create(
        user_name: user_name,
        password:  password
      )
    end

    subject { described_class }

    it "must query all #{described_class} with the matching password" do
      credential = subject.with_password(clear_text).first

      expect(credential).to be_kind_of(described_class)
      expect(credential.password.clear_text).to eq(clear_text)
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
      password:  Ronin::DB::Password.new(clear_text: clear_text)
    )
  end

  describe "#user" do
    it "must return the username String" do
      expect(subject.user).to eq(name)
    end
  end

  describe "#clear_text" do
    it "should provide the clear-text password String" do
      expect(subject.clear_text).to eq(clear_text)
    end
  end

  describe "#to_s" do
    it "should include the user name and password" do
      expect(subject.to_s).to eq("#{name}:#{clear_text}")
    end
  end
end
