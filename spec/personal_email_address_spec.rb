require 'spec_helper'
require 'ronin/db/personal_email_address'

describe Ronin::DB::PersonalEmailAddress do
  it "must use the 'ronin_personal_email_addresses' table" do
    expect(described_class.table_name).to eq('ronin_personal_email_addresses')
  end
end
