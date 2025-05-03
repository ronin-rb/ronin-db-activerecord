require 'spec_helper'
require 'ronin/db/os'

describe Ronin::DB::OS do
  it "must use the 'ronin_oses' table" do
    expect(described_class.table_name).to eq('ronin_oses')
  end

  let(:name)    { 'Linux'  }
  let(:version) { '2.6.11' }

  subject { described_class.new(name: name, version: version) }

  describe "validations" do
    describe "name" do
      it "should require a name" do
        os = described_class.new(version: version)

        expect(os).not_to be_valid

        os = described_class.new(name: name, version: version)

        expect(os).to be_valid
      end
    end

    describe "flavor" do
      it "must accept nil" do
        os = described_class.new(name: name, version: version)

        expect(os).to be_valid
      end

      it "must accept :linux" do
        os = described_class.new(name: 'Linux', flavor: :linux, version: '2.6.11')

        expect(os).to be_valid
      end

      it "must accept :bsd" do
        os = described_class.new(name: 'FreeBSD', flavor: :bsd, version: '14.2')

        expect(os).to be_valid
      end

      context "otherwise" do
        let(:flavor) { :other }

        it do
          expect {
            described_class.new(
              name:    'Other',
              flavor:  flavor,
              version: '1.2.3'
            )
          }.to raise_error(ArgumentError,"'#{flavor}' is not a valid flavor")
        end
      end
    end

    describe "version" do
      it "should require a version" do
        os = described_class.new(name: name)

        expect(os).not_to be_valid

        os = described_class.new(name: name, version: version)

        expect(os).to be_valid
      end
    end
  end

  describe ".with_flavor" do
    let(:flavor) { :linux }

    before do
      described_class.create(name: 'macOS',   flavor: :bsd,   version: '10.5')
      described_class.create(name: 'Linux',   flavor: flavor, version: '6.2.1')
      described_class.create(name: 'Ubuntu',  flavor: flavor, version: '22.0.1')
    end

    subject { described_class }

    it "must find all #{described_class} with the matching version" do
      software = subject.with_flavor(flavor)

      expect(software.length).to eq(2)
      expect(software.map(&:flavor).uniq).to eq([flavor.to_s])
    end

    after do
      described_class.destroy_all
    end
  end

  describe ".with_version" do
    let(:version) { '1.2.3' }

    before do
      described_class.create(name: 'macOS',   flavor: :bsd,   version: '10.5')
      described_class.create(name: 'Linux',   flavor: :linux, version: version)
      described_class.create(name: 'Ubuntu',  flavor: :linux, version: version)
    end

    subject { described_class }

    it "must find all #{described_class} with the matching version" do
      software = subject.with_version(version)

      expect(software.length).to eq(2)
      expect(software.map(&:version).uniq).to eq([version])
    end

    after do
      described_class.destroy_all
    end
  end

  describe ".linux" do
    let(:name) { 'Linux' }

    it "must find or create a new Linux OS" do
      os = described_class.linux(version)

      expect(os.name).to eq(name)
      expect(os.flavor).to eq('linux')
      expect(os.version).to eq(version)
    end
  end

  describe ".freebsd" do
    let(:name) { 'FreeBSD' }

    it "must find or create a new FreeBSD OS" do
      os = described_class.freebsd(version)

      expect(os.name).to eq(name)
      expect(os.flavor).to eq('bsd')
      expect(os.version).to eq(version)
    end
  end

  describe ".openbsd" do
    let(:name) { 'OpenBSD' }

    it "must find or create a new OpenBSD OS" do
      os = described_class.openbsd(version)

      expect(os.name).to eq(name)
      expect(os.flavor).to eq('bsd')
      expect(os.version).to eq(version)
    end
  end

  describe ".netbsd" do
    let(:name) { 'NetBSD' }

    it "must find or create a new NetBSD OS" do
      os = described_class.netbsd(version)

      expect(os.name).to eq(name)
      expect(os.flavor).to eq('bsd')
      expect(os.version).to eq(version)
    end
  end

  describe ".macos" do
    let(:name) { 'macOS' }

    it "must find or create a new macOS OS" do
      os = described_class.macos(version)

      expect(os.name).to eq(name)
      expect(os.flavor).to eq('bsd')
      expect(os.version).to eq(version)
    end
  end

  describe ".windows" do
    let(:name) { 'Windows' }

    it "must find or create a new Windows OS" do
      os = described_class.windows(version)

      expect(os.version).to eq(version)
    end
  end

  describe "#recent_ip_address"

  describe "#to_s" do
    it "must return the OS name and version" do
      expect(subject.to_s).to eq("#{name} #{version}")
    end
  end
end
