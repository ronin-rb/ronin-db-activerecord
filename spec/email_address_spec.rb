require 'spec_helper'
require 'ronin/db/email_address'

describe Ronin::DB::EmailAddress do
  it "must use the 'ronin_email_addresses' table" do
    expect(described_class.table_name).to eq('ronin_email_addresses')
  end

  let(:user)    { 'joe'             }
  let(:host)    { 'example.com'     }
  let(:address) { "#{user}@#{host}" }

  let(:user_name) { Ronin::DB::UserName.new(name: user) }
  let(:host_name) { Ronin::DB::HostName.new(name: host) }

  subject do
    described_class.new(
      user_name: user_name,
      host_name: host_name
    )
  end

  describe "validations" do
    describe "address" do
      it "must require an email address" do
        email_address = described_class.new(
          user_name: user_name,
          host_name: host_name
        )
        expect(email_address).to_not be_valid
        expect(email_address.errors[:address]).to include(
          "can't be blank"
        )

        email_address = described_class.new(
          address: address,
          user_name: user_name,
          host_name: host_name
        )
        expect(email_address).to be_valid
      end

      it "must require a valid email address" do
        email_address = described_class.new(
          address: "foo AT bar DOT com",
          user_name: user_name,
          host_name: host_name
        )
        expect(email_address).to_not be_valid
        expect(email_address.errors[:address]).to eq(
          ["Must be a valid email address"]
        )

        email_address = described_class.new(
          address: address,
          user_name: user_name,
          host_name: host_name
        )
        expect(email_address).to be_valid
      end

      it "must not allow email addresses longer than 320 characters" do
        email_address = described_class.new(
          address:   "#{'a' * 320}@example.com",
          user_name: user_name,
          host_name: host_name
        )
        expect(email_address).to_not be_valid
        expect(email_address.errors[:address]).to eq(
          ["is too long (maximum is 320 characters)"]
        )

        email_address = described_class.new(
          address:   address,
          user_name: user_name,
          host_name: host_name
        )
        expect(email_address).to be_valid
      end

      it "must require a unique email address" do
        user_name.save
        host_name.save

        email_address = described_class.create(
          address:   address,
          user_name: user_name,
          host_name: host_name
        )
        expect(email_address).to be_valid

        email_address = described_class.new(
          address:   address,
          user_name: user_name,
          host_name: host_name
        )

        expect(email_address).to_not be_valid
        expect(email_address.errors[:address]).to eq(
          ["has already been taken"]
        )

        described_class.destroy_all
        user_name.destroy
        host_name.destroy
      end
    end

    describe "host_name" do
      it "must require a host_name" do
        email_address = described_class.new(
          address: address,
          user_name: user_name
        )
        expect(email_address).to_not be_valid
        expect(email_address.errors[:host_name]).to include(
          "must exist"
        )

        email_address = described_class.new(
          address:   address,
          user_name: user_name,
          host_name: host_name
        )
        expect(email_address).to be_valid
      end
    end

    describe "user_name" do
      it "must require a user_name" do
        email_address = described_class.new(
          address: address,
          host_name: host_name
        )
        expect(email_address).to_not be_valid
        expect(email_address.errors[:user_name]).to include(
          "must exist"
        )

        email_address = described_class.new(
          address:   address,
          user_name: user_name,
          host_name: host_name
        )
        expect(email_address).to be_valid
      end

      it "must require a unique combination of host_name and user_name" do
        user_name.save
        host_name.save

        email_address = described_class.create(
          address:   address,
          user_name: user_name,
          host_name: host_name
        )
        expect(email_address).to be_valid

        email_address = described_class.new(
          address:   address,
          user_name: user_name,
          host_name: host_name
        )
        expect(email_address).to_not be_valid
        expect(email_address.errors[:user_name]).to eq(
          ["has already been taken"]
        )

        described_class.destroy_all
        user_name.destroy
        host_name.destroy
      end
    end
  end

  describe ".with_host_name" do
    subject { described_class }

    let(:user_name) { Ronin::DB::UserName.create(name: user) }
    let(:host_name) { Ronin::DB::HostName.create(name: host) }

    before do
      described_class.create(
        address:   address,
        user_name: user_name,
        host_name: host_name
      )
    end

    it "must find the #{described_class} with the associated host name" do
      email_address = subject.with_host_name(host).first

      expect(email_address).to be_kind_of(described_class)
      expect(email_address.host_name.name).to eq(host)
    end

    after do
      described_class.destroy_all
      user_name.destroy
      host_name.destroy
    end
  end

  describe ".with_ip_address" do
    subject { described_class }

    let(:user_name) { Ronin::DB::UserName.create(name: user) }
    let(:host_name) { Ronin::DB::HostName.create(name: host) }

    let(:ip) { '93.184.216.34' }
    let(:ip_address) { Ronin::DB::IPAddress.create(address: ip) }

    before do
      email_address = described_class.create(
        address:   address,
        user_name: user_name,
        host_name: host_name
      )
      email_address.host_name.ip_addresses << ip_address
    end

    it "must find the #{described_class} with the associated IP address" do
      email_address = subject.with_ip_address(ip).first

      expect(email_address).to be_kind_of(described_class)
      expect(email_address.ip_addresses.first.address).to eq(ip)
    end

    after do
      described_class.destroy_all
      ip_address.destroy
      user_name.destroy
      host_name.destroy
    end
  end

  describe ".with_user_name" do
    subject { described_class }

    let(:user_name) { Ronin::DB::UserName.create(name: user) }
    let(:host_name) { Ronin::DB::HostName.create(name: host) }

    before do
      described_class.create(
        address:   address,
        user_name: user_name,
        host_name: host_name
      )
    end

    it "must find the #{described_class} with the associated user name" do
      email_address = subject.with_user_name(user).first

      expect(email_address).to be_kind_of(described_class)
      expect(email_address.user_name.name).to eq(user)
    end

    after do
      described_class.destroy_all
      user_name.destroy
      host_name.destroy
    end
  end

  describe ".with_password" do
    let(:plain_text) { 'secret' }

    before do
      user_name     = Ronin::DB::UserName.create(name: user)
      host_name     = Ronin::DB::HostName.create(name: host)
      email_address = Ronin::DB::EmailAddress.create(
        address:   address,
        user_name: user_name,
        host_name: host_name
      )

      password  = Ronin::DB::Password.create(plain_text: plain_text)

      Ronin::DB::Credential.create(
        email_address: email_address,
        password:      password
      )
    end

    subject { described_class }

    it "must query all #{described_class} that are associated with the password" do
      email_address = subject.with_password(plain_text).first

      expect(email_address).to be_kind_of(described_class)
      expect(email_address.passwords.map(&:plain_text)).to eq([plain_text])
    end

    after do
      Ronin::DB::Credential.destroy_all
      Ronin::DB::Password.destroy_all
      Ronin::DB::EmailAddress.destroy_all
      Ronin::DB::UserName.destroy_all
      Ronin::DB::HostName.destroy_all
    end
  end

  describe ".lookup" do
    let(:user_name) { Ronin::DB::UserName.create(name: user) }
    let(:host_name) { Ronin::DB::HostName.create(name: host) }

    before do
      described_class.create(
        address: 'other_user1@other_host1.com',
        user_name: Ronin::DB::UserName.create(name: 'other_user1'),
        host_name: Ronin::DB::HostName.create(name: 'other_host1')
      )

      described_class.create(
        address:   address,
        user_name: user_name,
        host_name: host_name
      )

      described_class.create(
        address: 'other_user2@other_host2.com',
        user_name: Ronin::DB::UserName.create(name: 'other_user2'),
        host_name: Ronin::DB::HostName.create(name: 'other_host2')
      )
    end

    it "must query the #{described_class} with the given address" do
      email_address = described_class.lookup(address)

      expect(email_address.address).to eq(address)
    end

    after do
      described_class.destroy_all
      user_name.destroy
      host_name.destroy
    end
  end

  describe ".import" do
    context "when given a valid email address" do
      subject { described_class.import(address) }

      it "must parse and import the email address" do
        expect(subject.user_name.name).to eq(user)
        expect(subject.host_name.name).to eq(host)
      end

      after do
        subject.destroy
        subject.user_name.destroy
        subject.host_name.destroy
      end
    end

    context "when the email address does not have a user name" do
      subject { described_class }

      let(:address) { "@#{host}" }

      it do
        expect {
          subject.import(address)
        }.to raise_error(ArgumentError,"invalid email address: #{address.inspect}")
      end
    end

    context "when the email address does not have a host name" do
      subject { described_class }

      let(:address) { "#{user}@" }

      it do
        expect {
          subject.import(address)
        }.to raise_error(ArgumentError,"invalid email address: #{address.inspect}")
      end
    end

    context "when the email address contains spaces" do
      subject { described_class }

      let(:address) { "#{user} @ #{host}" }

      it do
        expect {
          subject.import(address)
        }.to raise_error(ArgumentError,"invalid email address: #{address.inspect}")
      end
    end

    context "when the email address does not contain an '@' symbol" do
      subject { described_class }

      let(:address) { "#{user}" }

      it do
        expect {
          subject.import(address)
        }.to raise_error(ArgumentError,"invalid email address: #{address.inspect}")
      end
    end
  end

  describe "#user" do
    it "must return the user-name" do
      expect(subject.user).to eq(user)
    end
  end

  describe "#host" do
    it "must return the host-name" do
      expect(subject.host).to eq(host)
    end
  end

  describe "#to_s" do
    it "should include the email address" do
      expect(subject.to_s).to eq(address)
    end
  end
end
