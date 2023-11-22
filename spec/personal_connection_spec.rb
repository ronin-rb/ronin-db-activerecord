require 'spec_helper'
require 'ronin/db/personal_connection'

describe Ronin::DB::PersonalConnection do
  it "must use the 'ronin_personal_connections' table" do
    expect(described_class.table_name).to eq('ronin_personal_connections')
  end
end
