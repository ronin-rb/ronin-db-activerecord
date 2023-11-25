require 'spec_helper'
require 'ronin/db/organization_street_address'

describe Ronin::DB::OrganizationStreetAddress do
  it "must use the 'ronin_organization_street_addresses' table" do
    expect(described_class.table_name).to eq('ronin_organization_street_addresses')
  end
end
