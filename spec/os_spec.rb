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
      it "must require a name" do
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

      it "must accept 'linux'" do
        os = described_class.new(
          name:    'Linux',
          flavor:  'Linux',
          version: '2.6.11'
        )

        expect(os).to be_valid
      end

      it "must accept 'bsd'" do
        os = described_class.new(
          name:    'FreeBSD',
          flavor:  'BSD',
          version: '14.2'
        )

        expect(os).to be_valid
      end

      it "must not accept other values" do
        os = described_class.new(
          name:    'Other',
          flavor:  'other',
          version: '1.2.3'
        )

        expect(os).to_not be_valid
        expect(os.errors[:flavor]).to eq(['is not included in the list'])
      end
    end

    describe "version" do
      it "must require a version" do
        os = described_class.new(name: name)

        expect(os).not_to be_valid

        os = described_class.new(name: name, version: version)

        expect(os).to be_valid
      end
    end
  end

  describe ".with_flavor" do
    let(:flavor) { 'Linux' }

    before do
      described_class.create(name: 'macOS',   flavor: 'BSD',  version: '10.5')
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
      described_class.create(name: 'macOS',   flavor: 'BSD',   version: '10.5')
      described_class.create(name: 'Linux',   flavor: 'Linux', version: version)
      described_class.create(name: 'Ubuntu',  flavor: 'Linux', version: version)
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
      expect(os.flavor).to eq('Linux')
      expect(os.version).to eq(version)
    end
  end

  describe ".freebsd" do
    let(:name) { 'FreeBSD' }

    it "must find or create a new FreeBSD OS" do
      os = described_class.freebsd(version)

      expect(os.name).to eq(name)
      expect(os.flavor).to eq('BSD')
      expect(os.version).to eq(version)
    end
  end

  describe ".openbsd" do
    let(:name) { 'OpenBSD' }

    it "must find or create a new OpenBSD OS" do
      os = described_class.openbsd(version)

      expect(os.name).to eq(name)
      expect(os.flavor).to eq('BSD')
      expect(os.version).to eq(version)
    end
  end

  describe ".netbsd" do
    let(:name) { 'NetBSD' }

    it "must find or create a new NetBSD OS" do
      os = described_class.netbsd(version)

      expect(os.name).to eq(name)
      expect(os.flavor).to eq('BSD')
      expect(os.version).to eq(version)
    end
  end

  describe ".macos" do
    let(:name) { 'macOS' }

    it "must find or create a new macOS OS" do
      os = described_class.macos(version)

      expect(os.name).to eq(name)
      expect(os.flavor).to eq('BSD')
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

  describe "#linux?" do
    context "when #flavor is 'Linux'" do
      subject do
        described_class.new(name: 'Linux', flavor: 'Linux', version: '2.6.11')
      end

      it "must return true" do
        expect(subject.linux?).to be(true)
      end
    end

    context "when #flavor is not 'Linux'" do
      subject do
        described_class.new(name: 'Other', version: '1.2.3')
      end

      it "must return false" do
        expect(subject.linux?).to be(false)
      end
    end
  end

  describe "#bsd?" do
    context "when #flavor is 'BSD'" do
      subject do
        described_class.new(name: 'FreeBSD', flavor: 'BSD', version: '14.5')
      end

      it "must return true" do
        expect(subject.bsd?).to be(true)
      end
    end

    context "when #flavor is not 'BSD'" do
      subject do
        described_class.new(name: 'Other', version: '1.2.3')
      end

      it "must return false" do
        expect(subject.bsd?).to be(false)
      end
    end
  end

  describe "#to_s" do
    it "must return the OS name and version" do
      expect(subject.to_s).to eq("#{name} #{version}")
    end
  end
end
