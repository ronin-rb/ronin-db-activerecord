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

  describe ".between" do
    subject { described_class }

    let(:address1) { '4.1.1.1' }
    let(:address2) { '4.2.2.2' }
    let(:address3) { '4.3.3.3' }

    before do
      described_class.create(address: '4.0.0.0')
      described_class.create(address: address1)
      described_class.create(address: address2)
      described_class.create(address: address3)
      described_class.create(address: '4.4.4.4')
    end

    it "must query all IP addresses that are in between the first and last IP address" do
      ip_addresses = subject.between(address1,address3)

      expect(ip_addresses.length).to eq(3)
      expect(ip_addresses).to all(be_kind_of(described_class))
      expect(ip_addresses[0].address).to eq(address1)
      expect(ip_addresses[1].address).to eq(address2)
      expect(ip_addresses[2].address).to eq(address3)
    end

    after { described_class.destroy_all }
  end

  describe ".in_range" do
    subject { described_class }

    let(:address1) { '4.1.1.1' }
    let(:address2) { '4.2.2.2' }
    let(:address3) { '4.3.3.3' }
    let(:range)    { address1..address3 }

    before do
      described_class.create(address: '4.0.0.0')
      described_class.create(address: address1)
      described_class.create(address: address2)
      described_class.create(address: address3)
      described_class.create(address: '4.4.4.4')
    end

    it "must query all IP addresses that are in between the first and last IP address" do
      ip_addresses = subject.in_range(range)

      expect(ip_addresses.length).to eq(3)
      expect(ip_addresses).to all(be_kind_of(described_class))
      expect(ip_addresses[0].address).to eq(address1)
      expect(ip_addresses[1].address).to eq(address2)
      expect(ip_addresses[2].address).to eq(address3)
    end

    after { described_class.destroy_all }
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

  describe ".lookup" do
    before do
      described_class.create(address: '1.2.4.5')
      described_class.create(address: address)
      described_class.create(address: '6.7.8.9')
    end

    it "must query the #{described_class} with the matching IP address" do
      ip_address = described_class.lookup(address)

      expect(ip_address).to be_kind_of(described_class)
      expect(ip_address.address).to eq(address)
    end

    after { described_class.destroy_all }
  end

  describe ".import" do
    subject { described_class.import(address) }

    it "must parse and import the IP address and set #address" do
      expect(subject).to be_kind_of(described_class)
      expect(subject.id).to_not be(nil)
      expect(subject.address).to eq(address)
    end

    after { described_class.destroy_all }
  end

  describe "#ipaddr" do
    it "must automatically parse #address and return an IPAddr" do
      expect(subject.ipaddr).to be_kind_of(IPAddr)
      expect(subject.ipaddr.to_s).to eq(address)
    end

    context "when the address is an IPv4 address" do
      let(:address) { ipv4_address }

      it "must return an IPv4 IPAddr" do
        expect(subject.ipaddr.ipv4?).to be(true)
      end
    end

    context "when the address is an IPv6 address" do
      let(:address) { ipv6_address }

      it "must return an IPv6 IPAddr" do
        expect(subject.ipaddr.ipv6?).to be(true)
      end
    end

    context "when the address is not a valid IP address" do
      let(:address) { '0' }

      it "must return nil" do
        expect(subject.ipaddr).to be(nil)
      end
    end
  end

  describe "#version" do
    it "must only accept 4 or 6" do
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

  describe "#asn" do
    let(:asn_version)      { 4 }
    let(:asn_range_start)  { '4.0.0.0' }
    let(:asn_range_end)    { '4.7.168.255' }
    let(:asn_number)       { 3356 }
    let(:asn_country_code) { 'US' }
    let(:asn_name)         { 'LEVEL3' }

    before do
      Ronin::DB::ASN.create(
        version:      6,
        range_start:  '64:ff9b::1:0:0',
        range_end:    '100::ffff:ffff:ffff:ffff',
        number:       0
      )

      Ronin::DB::ASN.create(
        version:      asn_version,
        range_start:  asn_range_start,
        range_end:    asn_range_end,
        number:       asn_number,
        country_code: asn_country_code,
        name:         asn_name
      )

      Ronin::DB::ASN.create(
        version:      6,
        range_start:  '::',
        range_end:    '::1',
        number:       0
      )
    end

    let(:version) { 4 }
    let(:address) { '4.4.4.4' }

    subject do
      described_class.new(
        version: version,
        address: address
      )
    end

    it "must lookup the ASN record containing the IP address" do
      asn = subject.asn

      expect(asn).to be_kind_of(Ronin::DB::ASN)
      expect(asn.version).to eq(version)
      expect(asn.range_start).to eq('4.0.0.0')
      expect(asn.range_end).to eq('4.7.168.255')
    end

    after do
      Ronin::DB::ASN.destroy_all
    end
  end

  describe "#recent_mac_address"

  describe "#recent_host_name"

  describe "#recent_os_guess"

  describe "#save" do
    subject { described_class.create(address: address) }

    it "must set hton" do
      expect(subject.hton).to eq(subject.ipaddr.hton)
    end

    after { subject.destroy }
  end

  describe "#to_ip"

  describe "#to_i"
end
