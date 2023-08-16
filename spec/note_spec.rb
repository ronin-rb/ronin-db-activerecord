require 'spec_helper'
require 'ronin/db/note'

describe Ronin::DB::Note do
  describe "validations" do
    it "must require a body" do
      note = described_class.new

      expect(note).to_not be_valid
      expect(note.errors[:body]).to eq(
        ["can't be blank"]
      )
    end

    it "must have at least one belongs_to association set" do
      note = described_class.new(body: 'Test')

      expect(note).to_not be_valid
      expect(note.errors[:base]).to eq(
        ['note must be associated with a MACAddress, IPAddress, HostName, Port, Service, OpenPort, Cert, URL, UserName, EmailAddress, Password, Credential, Advisory, PhoneNumber, StreetAddress, or Organization']
      )

      note = described_class.new(
        body:       'Test',
        ip_address: Ronin::DB::IPAddress.new(
          address: '192.168.1.1'
        )
      )
      expect(note).to be_valid
    end
  end
end
