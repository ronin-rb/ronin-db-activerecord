require 'spec_helper'
require 'ronin/db/organization_member'

describe Ronin::DB::OrganizationMember do
  it "must use the 'ronin_organization_members' table" do
    expect(described_class.table_name).to eq('ronin_organization_members')
  end
end
