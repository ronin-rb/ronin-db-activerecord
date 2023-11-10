require 'spec_helper'
require 'ronin/db/organization_email_address'

describe Ronin::DB::OrganizationEmailAddress do
  it "must use the 'ronin_organization_email_addresses' table" do
    expect(described_class.table_name).to eq('ronin_organization_email_addresses')
  end
end
