require 'spec_helper'
require 'ronin/db/port'

describe Ronin::DB::Port do
  it "must use the 'ronin_ports' table" do
    expect(described_class.table_name).to eq('ronin_ports')
  end

  let(:protocol) { 'tcp' }
  let(:number)   { 80 }

  subject do
    described_class.new(protocol: protocol, number: number)
  end

  describe "validations" do
    it "must require a port number" do
      port = described_class.new(protocol: protocol)

      expect(port).not_to be_valid
      expect(port.errors[:number]).to eq(
        ["can't be blank", "is not a number"]
      )
    end

    describe "protocol" do
      [
        :tcp,
        :udp
      ].each do |valid_protocol|
        it "must accept #{valid_protocol.inspect}" do
          port = described_class.new(protocol: valid_protocol, number: number)

          expect(port).to be_valid
        end
      end

      it "must not accept other values" do
        expect {
          described_class.new(protocol: :other, number: number)
        }.to raise_error(ArgumentError,"'other' is not a valid protocol")
      end
    end

    it "must only allow saving unique protocol/port-number pairs" do
      described_class.create(protocol: protocol, number: number)

      port2 = described_class.new(protocol: protocol, number: number)

      expect(port2).to_not be_valid
      expect(port2.errors[:number]).to eq(["has already been taken"])
    end

    after { described_class.destroy_all }
  end

  describe ".with_number" do
    subject { described_class }

    context "when given an Integer" do
      before do
        described_class.create(number: 22)
        described_class.create(number: 80, protocol: :tcp)
        described_class.create(number: 80, protocol: :udp)
        described_class.create(number: 443)
        described_class.create(number: 8080)
        described_class.create(number: 9000)
      end

      it "must query all #{described_class} with the matching #number" do
        ports = subject.with_number(80)

        expect(ports).to_not be_empty
        expect(ports.map(&:number).uniq).to eq([80])
      end

      after do
        described_class.destroy_all
      end
    end

    context "when given a Range" do
      before do
        described_class.create(number: 22)
        described_class.create(number: 80)
        described_class.create(number: 443)
        described_class.create(number: 8080)
        described_class.create(number: 9000)
      end

      it "must query all #{described_class} who's #number is within the port range" do
        ports = subject.with_number(80..1024)

        expect(ports).to_not be_empty
        expect(ports.map(&:number)).to eq([80, 443])
      end

      after do
        described_class.destroy_all
      end
    end
  end

  describe ".with_protocol" do
    before do
      described_class.create(number: 22)
      described_class.create(number: 53, protocol: :udp)
      described_class.create(number: 80)
      described_class.create(number: 443)
      described_class.create(number: 8080, protocol: :udp)
      described_class.create(number: 9000)
    end

    subject { described_class }

    it "must query all #{described_class} with the matching #protocol" do
      ports = subject.with_protocol(:udp)

      expect(ports).to_not be_empty
      expect(ports.map(&:protocol).uniq).to eq(['udp'])
    end

    after do
      described_class.destroy_all
    end
  end

  describe ".with_service_name" do
    let(:number) { 22 }
    let(:name)   { 'ssh' }

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

    it "must query all #{described_class} associated with the service name" do
      port = subject.with_service_name(name).first

      expect(port).to be_kind_of(described_class)
      expect(port.services.map(&:name)).to include(name)
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
    let(:name)    { 'ssh' }
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
      port = subject.with_ip_address(address).first

      expect(port).to be_kind_of(described_class)
      expect(port.ip_addresses.map(&:address)).to include(address)
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
      described_class.create(number: 1111)
      described_class.create(number: number)
      described_class.create(number: 2222)
    end

    it "must query the #{described_class} with the matching port number" do
      port = described_class.lookup(number)

      expect(port).to be_kind_of(described_class)
      expect(port.number).to eq(number)
    end

    after { described_class.destroy_all }
  end

  describe ".import" do
    context "when given an Integer" do
      subject { described_class.import(number) }

      it "must import the port number and set #number" do
        expect(subject).to be_kind_of(described_class)
        expect(subject.id).to_not be(nil)
        expect(subject.number).to eq(number)
      end
    end

    context "when given a String" do
      let(:string) { number.to_s }

      subject { described_class.import(string) }

      it "must parse and import the port number and set #number" do
        expect(subject).to be_kind_of(described_class)
        expect(subject.id).to_not be(nil)
        expect(subject.number).to eq(number)
      end
    end

    after { described_class.destroy_all }
  end

  describe "#tcp?" do
    context "when #protocol is :tcp" do
      let(:protocol) { :tcp }

      it "must return true" do
        expect(subject.tcp?).to be(true)
      end
    end

    context "when #protocol is not :tcp" do
      let(:protocol) { :udp }

      it "must return false" do
        expect(subject.tcp?).to be(false)
      end
    end
  end

  describe "#udp?" do
    context "when #protocol is :udp" do
      let(:protocol) { :udp }

      it "must return true" do
        expect(subject.udp?).to be(true)
      end
    end

    context "when #protocol is not :udp" do
      let(:protocol) { :tcp }

      it "must return false" do
        expect(subject.udp?).to be(false)
      end
    end
  end

  describe "#to_i" do
    it "must be convertable to an Integer" do
      expect(subject.to_i).to eq(number)
    end
  end

  describe "#to_s" do
    it "must include the number and protocol" do
      expect(subject.to_s).to eq("#{number}/#{protocol}")
    end
  end
end
