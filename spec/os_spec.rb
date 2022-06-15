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

    describe "version" do
      it "should require a version" do
        os = described_class.new(name: name)
        expect(os).not_to be_valid

        os = described_class.new(name: name, version: version)
        expect(os).to be_valid
      end
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

  describe "#recent_ip_address" do
  end

  describe "#to_s" do
    it "must return the OS name and version" do
      expect(subject.to_s).to eq("#{name} #{version}")
    end
  end
end
