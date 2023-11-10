require 'spec_helper'
require 'ronin/db/personal_phone_number'

describe Ronin::DB::PersonalPhoneNumber do
  it "must use the 'ronin_personal_phone_numbers' table" do
    expect(described_class.table_name).to eq('ronin_personal_phone_numbers')
  end
end
