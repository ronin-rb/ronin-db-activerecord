require 'spec_helper'
require 'ronin/db/dns_query'

describe Ronin::DB::DNSQuery do
  it "must use the 'ronin_dns_queries' table" do
    expect(described_class.table_name).to eq('ronin_dns_queries')
  end
end
