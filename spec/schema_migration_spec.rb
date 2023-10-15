require 'spec_helper'
require 'ronin/db/schema_migration'

describe Ronin::DB::SchemaMigration do
  let(:connection) { ActiveRecord::Tasks::DatabaseTasks.migration_connection }

  subject { described_class.new(connection) }

  it "must use the 'ronin_schema_migrations' table" do
    expect(subject.table_name).to eq('ronin_schema_migrations')
  end
end
