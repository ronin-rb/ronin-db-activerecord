require 'spec_helper'
require 'ronin/db/organization_department'

describe Ronin::DB::OrganizationDepartment do
  it "must use the 'ronin_organization_departments' table" do
    expect(described_class.table_name).to eq('ronin_organization_departments')
  end

  describe "validations" do
    it "must require a unique name, per Organization" do
      org1 = Ronin::DB::Organization.create(name: 'Org1')
      org2 = Ronin::DB::Organization.create(name: 'Org2')

      department1 = described_class.create(
        name: 'Accounting',
        organization: org1
      )

      department2 = described_class.create(
        name: 'Accounting',
        organization: org2
      )

      department3 = described_class.create(
        name: 'Accounting',
        organization: org2
      )

      expect(department1).to be_valid
      expect(department2).to be_valid
      expect(department3).to_not be_valid
      expect(department3.errors[:name]).to eq(["has already been taken"])
    end
  end
end
