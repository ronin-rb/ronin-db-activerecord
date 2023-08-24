require 'spec_helper'
require 'ronin/db/open_port'

describe Ronin::DB::OpenPort do
  it "must use the 'ronin_open_ports' table" do
    expect(described_class.table_name).to eq('ronin_open_ports')
  end

  let(:port_number)   { 443  }
  let(:port_protocol) { :tcp }
  let(:port) do
    Ronin::DB::Port.new(protocol: port_protocol, number: port_number)
  end

  let(:address)    { '127.0.0.1' }
  let(:ip_address) { Ronin::DB::IPAddress.new(address: address) }

  describe "validations" do
    describe "ip_address" do
      it "must require an ip_address" do
        open_port = described_class.new(port: port)
        expect(open_port).to_not be_valid
        expect(open_port.errors[:ip_address]).to eq(
          ["must exist"]
        )

        open_port = described_class.new(ip_address: ip_address, port: port)
        expect(open_port).to be_valid
      end
    end

    describe "port" do
      it "must require an ip_address" do
        open_port = described_class.new(ip_address: ip_address)
        expect(open_port).to_not be_valid
        expect(open_port.errors[:port]).to eq(
          ["must exist"]
        )

        open_port = described_class.new(ip_address: ip_address, port: port)
        expect(open_port).to be_valid
      end
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
      open_port = subject.with_service_name(name).first

      expect(open_port).to be_kind_of(described_class)
      expect(open_port.service.name).to eq(name)
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
      open_port = subject.with_ip_address(address).first

      expect(open_port).to be_kind_of(described_class)
      expect(open_port.ip_address.address).to eq(address)
    end

    after do
      Ronin::DB::OpenPort.destroy_all
      Ronin::DB::IPAddress.destroy_all
      Ronin::DB::Service.destroy_all
      Ronin::DB::Port.destroy_all
    end
  end

  subject { described_class.new(ip_address: ip_address, port: port) }

  describe "#address" do
    it "must return the IP address String associated with the open port" do
      expect(subject.address).to eq(address)
    end
  end

  describe "#number" do
    it "must return the port number associated with the open port" do
      expect(subject.number).to eq(port_number)
    end
  end

  describe "#to_i" do
    it "must return the port number associated with the open port" do
      expect(subject.to_i).to eq(port_number)
    end
  end

  describe "#to_s" do
    it "must return the port protocol/number associated with the open port" do
      expect(subject.to_s).to eq("#{port_number}/#{port_protocol}")
    end

    context "when #service is also set" do
      let(:service_name) { 'Apache' }
      let(:service)      { Ronin::DB::Service.new(name: service_name) }

      subject do
        described_class.new(
          ip_address: ip_address,
          port:       port,
          service:    service
        )
      end
      it "must return the port number and service name" do
        expect(subject.to_s).to eq("#{port_number}/#{port_protocol} (#{service_name})")
      end
    end
  end
end
