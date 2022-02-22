require 'spec_helper'
require 'ronin/db/service_credential'

describe Ronin::DB::ServiceCredential do
  it "must use the 'ronin_credentials' table" do
    expect(described_class.table_name).to eq('ronin_credentials')
  end
end
