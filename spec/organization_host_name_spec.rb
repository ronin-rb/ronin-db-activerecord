require 'spec_helper'
require 'ronin/db/organization_host_name'

describe Ronin::DB::OrganizationHostName do
  it "must use the 'ronin_organization_host_names' table" do
    expect(described_class.table_name).to eq('ronin_organization_host_names')
  end
end
