require 'spec_helper'
require 'ronin/db/model/has_unique_name'

describe Ronin::DB::Model::HasUniqueName do
  class TestModelHasUniqueName < ActiveRecord::Base
    include Ronin::DB::Model::HasUniqueName

    self.table_name = 'test_model_has_unique_name'
  end

  let(:model) { TestModelHasUniqueName }

  before(:all) do
    ActiveRecord::Base.connection.create_table :test_model_has_unique_name do |t|
      t.string :name
    end
  end

  describe ".included" do
    subject { model }

    it "should include Ronin::DB::Model" do
      expect(subject.ancestors).to include(Ronin::DB::Model)
    end

    it "should include Ronin::DB::Model::HasName::InstanceMethods" do
      expect(subject.ancestors).to include(Ronin::DB::Model::HasName::InstanceMethods)
    end

    it "should define a name attribute" do
      expect(subject.new).to respond_to(:name)
      expect(subject.new).to respond_to(:name=)
    end
  end

  describe "validations" do
    subject { model }

    it "should require a name" do
      record = subject.new
      expect(record).to_not be_valid

      record.name = 'foo'
      expect(record).to be_valid
    end

    context "when the given name already exists in the table" do
      let(:name) { 'foo' }

      before { model.create(name: name) }

      it "must require a unique name" do
        record = subject.new(name: name)

        expect(record).to_not be_valid
      end

      after { model.destroy_all }
    end
  end
end
