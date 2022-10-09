require 'spec_helper'
require 'ronin/db/model/importable'

describe Ronin::DB::Model::Importable do
  class TestModelImportable < ActiveRecord::Base
    include Ronin::DB::Model::Importable

    self.table_name = 'test_model_importable'

    def self.lookup(value)
      find_by(value: value)
    end

    def self.import(value)
      create(value: value)
    end
  end

  class TestModelImportableWithoutMethods < ActiveRecord::Base
    include Ronin::DB::Model::Importable

    self.table_name = 'test_model_importable'
  end

  let(:model) { TestModelImportable }

  before(:all) do
    ActiveRecord::Base.connection.create_table :test_model_importable do |t|
      t.string :value

      t.index :value, unique: true
    end
  end

  let(:value) { "foo" }

  describe ".lookup" do
    subject { model }

    context "when not defined in the model class" do
      let(:model) { TestModelImportableWithoutMethods }

      it "must raise NotImplementedError" do
        expect {
          subject.lookup(value)
        }.to raise_error(NotImplementedError,"#{model} did not define a self.lookup method")
      end
    end
  end

  describe ".import" do
    subject { model }

    context "when not defined in the model class" do
      let(:model) { TestModelImportableWithoutMethods }

      it "must raise NotImplementedError" do
        expect {
          subject.import(value)
        }.to raise_error(NotImplementedError,"#{model} did not define a self.import method")
      end
    end
  end

  describe ".find_or_import" do
    subject { model }

    context "when a record with the matching value already exists" do
      before do
        model.create(value: 'other value1')
        model.create(value: value)
        model.create(value: 'other value2')
      end

      it "must query and return the existing record for the value" do
        record = subject.find_or_import(value)

        expect(record).to be_kind_of(model)
        expect(record).to be_persisted
        expect(record.value).to eq(value)
        expect(record).to eq(model.all[1])
      end

      after { model.destroy_all }
    end

    context "when a record with the matching value does not already exists" do
      before do
        model.create(value: 'other value1')
        model.create(value: 'other value2')
      end

      it "must create and return a new record for the value" do
        record = subject.find_or_import(value)

        expect(record).to be_kind_of(model)
        expect(record).to be_persisted
        expect(record.value).to eq(value)
        expect(record).to eq(model.last)
      end

      after { model.destroy_all }
    end
  end
end
