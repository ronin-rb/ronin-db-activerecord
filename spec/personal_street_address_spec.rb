require 'spec_helper'
require 'ronin/db/personal_street_address'

describe Ronin::DB::PersonalStreetAddress do
  it "must use the 'ronin_personal_street_addresses' table" do
    expect(described_class.table_name).to eq('ronin_personal_street_addresses')
  end
end
