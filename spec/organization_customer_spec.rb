require 'spec_helper'
require 'ronin/db/organization_customer'

describe Ronin::DB::OrganizationCustomer do
  it "must use the 'ronin_organization_customers' table" do
    expect(described_class.table_name).to eq('ronin_organization_customers')
  end
end
