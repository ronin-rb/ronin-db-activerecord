require 'spec_helper'
require 'ronin/db/schema_migration'

describe Ronin::DB::SchemaMigration do
  it "must use the 'ronin_schema_migrations' table" do
    expect(described_class.table_name).to eq('ronin_schema_migrations')
  end
end
