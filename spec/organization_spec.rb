require 'spec_helper'
require 'ronin/db/organization'

describe Ronin::DB::Organization do
  it "must use the 'ronin_organizations' table" do
    expect(described_class.table_name).to eq('ronin_organizations')
  end

  let(:name) { 'ACEM, Corp.' }
end
