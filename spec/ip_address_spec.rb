require 'spec_helper'

require 'ronin/db/ip_address'

describe Ronin::DB::IPAddress do
  it "must use the 'ronin_ip_addresses' table" do
    expect(described_class.table_name).to eq('ronin_ip_addresses')
  end

  let(:address) { '127.0.0.1' }

  let(:ipv4_address) { '93.184.216.34' }
  let(:ipv6_address) { '2606:2800:220:1:248:1893:25c8:1946' }

  subject { described_class.new(address: address) }

  describe "validations" do
    describe "address" do
      it "must require an address" do
        ip_address = described_class.new
        expect(ip_address).to_not be_valid

        ip_address = described_class.new(address: address)
        expect(ip_address).to be_valid
      end

      it "must accept IPv4 addresses" do
        ip_address = described_class.new(address: ipv4_address)
        expect(ip_address).to be_valid
      end
      
      it "must accept IPv6 addresses" do
        ip_address = described_class.new(address: ipv6_address)
        expect(ip_address).to be_valid
      end

      it "must not accept non-IP addresses" do
        ip_address = described_class.new(address: '0')
        expect(ip_address).to_not be_valid
        expect(ip_address.errors[:address]).to eq(
          ["Must be a valid IP address"]
        )
      end
    end
  end

  describe ".v4" do
    subject { described_class }

    before do
      subject.create(address: ipv4_address)
      subject.create(address: ipv6_address)
    end

    it "must query all #{described_class} with IPv4 addresses" do
      ip_addresses = subject.v4
      expect(ip_addresses.count).to eq(1)

      ip_address = ip_addresses.first
      expect(ip_address).to be_kind_of(described_class)
      expect(ip_address.address).to eq(ipv4_address)
    end

    after do
      subject.destroy_all
    end
  end

  describe ".v6" do
    subject { described_class }

    before do
      subject.create(address: ipv4_address)
      subject.create(address: ipv6_address)
    end

    it "must query all #{described_class} with IPv6 addresses" do
      ip_addresses = subject.v6
      expect(ip_addresses.count).to eq(1)

      ip_address = ip_addresses.first
      expect(ip_address).to be_kind_of(described_class)
      expect(ip_address.address).to eq(ipv6_address)
    end

    after do
      subject.destroy_all
    end
  end

  describe ".with_mac_address" do
    subject { described_class }

    let(:mac_address) { '00:01:02:03:04:05' }

    before do
      ip_address = subject.create(address: address)
      ip_address.mac_addresses.create(address: mac_address)
    end

    it "must query all #{described_class} with the associated MAC address" do
      ip_addresses = subject.with_mac_address(mac_address)
      expect(ip_addresses.count).to eq(1)

      ip_address = ip_addresses.first
      expect(ip_address.mac_addresses.first.address).to eq(mac_address)
    end

    after do
      Ronin::DB::IPAddressMACAddress.destroy_all
      Ronin::DB::IPAddress.destroy_all
      Ronin::DB::MACAddress.destroy_all
    end
  end

  describe ".with_host_name" do
    subject { described_class }

    let(:host) { 'example.com' }

    before do
      ip_address = subject.create(address: address)
      ip_address.host_names.create(name: host)
    end

    it "must query all #{described_class} with the associated host name" do
      ip_addresses = subject.with_host_name(host)
      expect(ip_addresses.count).to eq(1)

      ip_address = ip_addresses.first
      expect(ip_address.host_names.first.name).to eq(host)
    end

    after do
      Ronin::DB::HostNameIPAddress.destroy_all
      Ronin::DB::IPAddress.destroy_all
      Ronin::DB::HostName.destroy_all
    end
  end

  describe ".with_port_number" do
    subject { described_class }

    let(:port) { 443 }

    before do
      ip_address = subject.create(address: address)
      ip_address.ports.create(protocol: :tcp, number: 80)
      ip_address.ports.create(protocol: :tcp, number: port)
      ip_address.ports.create(protocol: :tcp, number: 8080)
    end

    it "must query all #{described_class} with the associated port number" do
      ip_addresses = subject.with_port_number(port)
      expect(ip_addresses.count).to eq(1)

      ip_address = ip_addresses.first
      expect(ip_address.ports[1].number).to eq(port)
    end

    after do
      Ronin::DB::OpenPort.destroy_all
      Ronin::DB::IPAddress.destroy_all
      Ronin::DB::Port.destroy_all
    end
  end

  describe "#ip_addr" do
    it "must automatically parse #address and return an IPAddr" do
      expect(subject.ip_addr).to be_kind_of(IPAddr)
      expect(subject.ip_addr.to_s).to eq(address)
    end

    context "when the address is an IPv4 address" do
      let(:address) { ipv4_address }

      it "must return an IPv4 IPAddr" do
        expect(subject.ip_addr.ipv4?).to be(true)
      end
    end

    context "when the address is an IPv6 address" do
      let(:address) { ipv6_address }

      it "must return an IPv6 IPAddr" do
        expect(subject.ip_addr.ipv6?).to be(true)
      end
    end

    context "when the address is not a valid IP address" do
      let(:address) { '0' }

      it "must return nil" do
        expect(subject.ip_addr).to be(nil)
      end
    end
  end

  describe "#version" do
    it "should only accept 4 or 6" do
      ip_address = described_class.new(address: '1.1.1.1', version: 7)

      expect(ip_address).not_to be_valid
    end

    context "with IPv4 address" do
      subject { described_class.new(address: '127.0.0.1') }

      it { expect(subject.version).to be == 4 }
    end

    context "with IPv6 address" do
      subject { described_class.new(address: '::1') }

      it { expect(subject.version).to be == 6 }
    end
  end

  describe "#recent_mac_address" do
  end

  describe "#recent_host_name" do
  end

  describe "#recent_os_guess" do
  end

  describe "#to_ip" do
  end

  describe "#to_i" do
  end
end
