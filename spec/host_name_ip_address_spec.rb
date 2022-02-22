require 'spec_helper'
require 'ronin/db/host_name_ip_address'

describe Ronin::DB::HostNameIPAddress do
  it "must use the 'ronin_host_name_ip_addresses' table" do
    expect(described_class.table_name).to eq('ronin_host_name_ip_addresses')
  end
end
