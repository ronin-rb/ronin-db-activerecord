require 'spec_helper'
require 'ronin/db/user_name'

describe Ronin::DB::UserName do
  it "must use the 'ronin_user_names' table" do
    expect(described_class.table_name).to eq('ronin_user_names')
  end

  it "must include Ronin::DB::Model::HasUniqueName" do
    expect(described_class).to include(Ronin::DB::Model::HasUniqueName)
  end

  let(:name) { 'jsmith' }

  subject { described_class.new(name: name) }

  describe "validations" do
    it "should require a name" do
      user = described_class.new
      expect(user).not_to be_valid

      user = described_class.new(name: name)
      expect(user).to be_valid
    end
  end
end
