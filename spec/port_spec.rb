require 'spec_helper'
require 'ronin/db/port'

describe Ronin::DB::Port do
  it "must use the 'ronin_ports' table" do
    expect(described_class.table_name).to eq('ronin_ports')
  end

  let(:protocol) { 'tcp' }
  let(:number)   { 80    }

  subject do
    described_class.new(protocol: protocol, number: number)
  end

  describe "validations" do
    context "when not given a port number" do
      subject { described_class.new(protocol: protocol) }

      it "must require a port number" do
        expect(subject).not_to be_valid
      end
    end

    context "when given an unknown protocol" do
      let(:protocol) { 'foo' }

      it "must only allow 'tcp' and 'udp' as protocols" do
        expect {
          described_class.new(protocol: protocol, number: number)
        }.to raise_error(ArgumentError,"'#{protocol}' is not a valid protocol")
      end
    end

    context "when a duplicate protocol/port-number pairs is saved" do
      before { subject.save }

      it "must only allow saving unique protocol/port-number pairs" do
        port = described_class.new(protocol: protocol, number: number)

        expect(port).not_to be_valid
      end

      after { subject.destroy }
    end
  end

  describe ".parse" do
    let(:string) { number.to_s }

    subject { described_class.parse(string) }

    it "must parse the port number and set #number" do
      expect(subject.number).to eq(number)
    end
  end

  describe ".from" do
    context "when given a String" do
      let(:string) { number.to_s }

      subject { described_class.from(string) }

      it "must convert the String to an Integer and set #number" do
        expect(subject.number).to eq(number)
      end
    end

    context "when given an Integer" do
      subject { described_class.from(number) }

      it "must return a #{described_class} with #number set" do
        expect(subject.number).to eq(number)
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
