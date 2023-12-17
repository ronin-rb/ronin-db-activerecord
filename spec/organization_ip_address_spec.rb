require 'spec_helper'
require 'ronin/db/organization_ip_address'

describe Ronin::DB::OrganizationIPAddress do
  it "must use the 'ronin_organization_ip_addresses' table" do
    expect(described_class.table_name).to eq('ronin_organization_ip_addresses')
  end
end
