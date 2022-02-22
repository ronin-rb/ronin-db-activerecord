require 'spec_helper'
require 'ronin/db/ip_address_mac_address'

describe Ronin::DB::IPAddressMACAddress do
  it "must use the 'ronin_ip_addresses_mac_address' table" do
    expect(described_class.table_name).to eq('ronin_ip_address_mac_addresses')
  end
end
