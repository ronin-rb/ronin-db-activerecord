require 'spec_helper'
require 'ronin/db/host_name'

describe Ronin::DB::HostName do
  it "must use the 'ronin_host_names' table" do
    expect(described_class.table_name).to eq('ronin_host_names')
  end

  it "must include Ronin::DB::Model::LastScannedat" do
    expect(described_class).to include(Ronin::DB::Model::LastScannedAt)
  end

  let(:name)    { 'example.com'   }
  let(:address) { '93.184.216.34' }

  describe "validations" do
    describe "name" do
      it "require an host name" do
        host_name = described_class.new
        expect(host_name).to_not be_valid

        host_name = described_class.new(name: name)
        expect(host_name).to be_valid
      end

      it "must require a unique name" do
        described_class.create(name: name)

        host_name = described_class.new(name: name)
        expect(host_name).to_not be_valid

        described_class.destroy_all
      end
    end
  end

  describe ".parse" do
    subject { described_class }

    let(:name) { 'example.com' }

    context "when the host name is not already in the database" do
      it "must return a new unsaved #{described_class} record" do
        host = subject.parse(name)

        expect(host).to be_kind_of(described_class)
        expect(host.id).to be(nil)
        expect(host.name).to eq(name)
      end
    end

    context "when the host nmae is already in the database" do
      before { subject.create(name: name) }

      it "must return the previously saved #{described_class} record" do
        host = subject.parse(name)

        expect(host).to be_kind_of(described_class)
        expect(host.id).to_not be(nil)
        expect(host.name).to eq(name)
      end

      after do
        described_class.destroy_all
      end
    end
  end

  describe ".with_ip_address" do
    subject { described_class }

    let(:name)    { 'example.com'   }
    let(:address) { '93.184.216.34' }

    before do
      host = subject.create(name: name)
      host.ip_addresses.create(address: address)
    end

    it "must find the #{described_class} with the associated IP address" do
      host = subject.with_ip_address([address]).first

      expect(host).to be_kind_of(described_class)
      expect(host.name).to eq(name)
      expect(host.ip_addresses[0].address).to eq(address)
    end

    after do
      Ronin::DB::HostNameIPAddress.destroy_all
      Ronin::DB::IPAddress.destroy_all
      Ronin::DB::HostName.destroy_all
    end
  end

  describe ".with_port_number" do
    subject { described_class }

    let(:port1) { 80  }
    let(:port2) { 443 }
    let(:ports) { [port1, port2] }

    before do
      host       = described_class.create(name: name)
      ip_address = host.ip_addresses.create(address: address)

      ip_address.ports.create(protocol: :tcp, number: port1)
      ip_address.ports.create(protocol: :tcp, number: port2)
    end

    it "must find the #{described_class} with the associated port numbers" do
      host = subject.with_port_number(ports).first

      expect(host).to be_kind_of(described_class)
      expect(host.name).to eq(name)
      expect(host.ports[0].number).to eq(port1)
      expect(host.ports[1].number).to eq(port2)
    end

    after do
      Ronin::DB::OpenPort.destroy_all
      Ronin::DB::Port.destroy_all
      Ronin::DB::HostNameIPAddress.destroy_all
      Ronin::DB::IPAddress.destroy_all
      Ronin::DB::HostName.destroy_all
    end
  end

  describe ".with_tld" do
    subject { described_class }

    let(:tld)    { 'co.uk' }
    let(:domain) { "example.#{tld}" }

    before do
      subject.create(name: domain)
    end

    it "must find the #{described_class} with the given TLD" do
      host_name = subject.with_tld(tld).first

      expect(host_name).to be_kind_of(described_class)
      expect(host_name.name).to eq(domain)
    end

    after do
      described_class.destroy_all
    end
  end

  describe ".with_domain" do
    subject { described_class }

    context "when the exact domain exists in the database" do
      let(:domain) { 'example.com' }

      before do
        subject.create(name: domain)
      end

      it "must query the domain" do
        host = subject.with_domain(domain).first

        expect(host).to be_kind_of(described_class)
        expect(host.name).to eq(domain)
      end

      after { subject.destroy_all }

      context "when other sub-domain names exist in the database" do
        let(:sub_domain1) { 'www.example.com'  }
        let(:sub_domain2) { 'mail.example.com' }

        before do
          subject.create(name: sub_domain1)
          subject.create(name: sub_domain2)
        end

        it "must query the domain and sub-domain names" do
          hosts = subject.with_domain(domain)

          expect(hosts[0]).to be_kind_of(described_class)
          expect(hosts[0].name).to eq(domain)

          expect(hosts[1]).to be_kind_of(described_class)
          expect(hosts[1].name).to eq(sub_domain1)

          expect(hosts[2]).to be_kind_of(described_class)
          expect(hosts[2].name).to eq(sub_domain2)
        end

        after { subject.destroy_all }
      end
    end
  end

  describe "#recent_ip_address" do
  end
end
