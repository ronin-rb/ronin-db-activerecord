require 'spec_helper'
require 'ronin/db/service'

describe Ronin::DB::Service do
  it "must use the 'ronin_services' table" do
    expect(described_class.table_name).to eq('ronin_services')
  end

  let(:name) { 'ssh' }

  describe "validations" do
    describe "name" do
      it "must require a name" do
        service = described_class.new
        expect(service).to_not be_valid
        expect(service.errors[:name]).to eq(
          ["can't be blank"]
        )

        service = described_class.new(name: name)
        expect(service).to be_valid
      end

      it "must require a unique name" do
        described_class.create(name: name)

        service = described_class.new(name: name)
        expect(service).not_to be_valid
        expect(service.errors[:name]).to eq(
          ["has already been taken"]
        )

        described_class.destroy_all
      end
    end
  end

  describe ".with_port_number" do
    let(:number) { 22 }

    before do
      port       = Ronin::DB::Port.create(number: number)
      service    = Ronin::DB::Service.create(name: name)
      ip_address = Ronin::DB::IPAddress.create(address: '192.168.1.1')

      Ronin::DB::OpenPort.create(
        port:       port,
        service:    service,
        ip_address: ip_address
      )
    end

    subject { described_class }

    it "must query all #{described_class} associated with the port number" do
      service = subject.with_port_number(number).first

      expect(service).to be_kind_of(described_class)
      expect(service.ports.map(&:number).uniq).to eq([number])
    end

    after do
      Ronin::DB::OpenPort.destroy_all
      Ronin::DB::IPAddress.destroy_all
      Ronin::DB::Service.destroy_all
      Ronin::DB::Port.destroy_all
    end
  end

  describe ".with_protocol" do
    let(:number)   { 53 }
    let(:protocol) { :udp }
    let(:name)     { 'named' }

    before do
      port       = Ronin::DB::Port.create(number: number, protocol: protocol)
      service    = Ronin::DB::Service.create(name: name)
      ip_address = Ronin::DB::IPAddress.create(address: '192.168.1.1')

      Ronin::DB::OpenPort.create(
        port:       port,
        service:    service,
        ip_address: ip_address
      )
    end

    subject { described_class }

    it "must query all #{described_class} associated with the protocol" do
      service = subject.with_protocol(protocol).first

      expect(service).to be_kind_of(described_class)
      expect(service.ports.map(&:protocol).uniq).to eq([protocol.to_s])
    end

    after do
      Ronin::DB::OpenPort.destroy_all
      Ronin::DB::IPAddress.destroy_all
      Ronin::DB::Service.destroy_all
      Ronin::DB::Port.destroy_all
    end
  end

  describe ".with_ip_address" do
    let(:number)  { 22 }
    let(:address) { '192.168.1.42' }

    before do
      port       = Ronin::DB::Port.create(number: number)
      service    = Ronin::DB::Service.create(name: name)
      ip_address = Ronin::DB::IPAddress.create(address: address)

      Ronin::DB::OpenPort.create(
        port:       port,
        service:    service,
        ip_address: ip_address
      )
    end

    subject { described_class }

    it "must query all #{described_class} associated with the IP address" do
      service = subject.with_ip_address(address).first

      expect(service).to be_kind_of(described_class)
      expect(service.ip_addresses.map(&:address).uniq).to eq([address])
    end

    after do
      Ronin::DB::OpenPort.destroy_all
      Ronin::DB::IPAddress.destroy_all
      Ronin::DB::Service.destroy_all
      Ronin::DB::Port.destroy_all
    end
  end

  describe ".lookup" do
    before do
      described_class.create(name: 'http')
      described_class.create(name: name)
      described_class.create(name: 'https')
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

  subject { described_class.new(name: name) }
end
