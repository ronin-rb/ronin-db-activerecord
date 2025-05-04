require 'spec_helper'
require 'ronin/db/model/has_name'

describe Ronin::DB::Model::HasName do
  class TestModelHasName < ActiveRecord::Base
    include Ronin::DB::Model::HasName

    self.table_name = 'test_model_has_name'
  end

  let(:model) { TestModelHasName }

  before(:all) do
    ActiveRecord::Base.connection.create_table :test_model_has_name do |t|
      t.string :name
    end
  end

  describe ".included" do
    subject { model }

    it "must include Ronin::DB::Model" do
      expect(subject.ancestors).to include(Ronin::DB::Model)
    end

    it "must define a name attribute" do
      expect(subject.new).to respond_to(:name)
      expect(subject.new).to respond_to(:name=)
    end
  end

  describe "validations" do
    subject { model }

    it "must require a name" do
      resource = subject.new
      expect(resource).not_to be_valid

      resource.name = 'foo'
      expect(resource).to be_valid
    end
  end

  describe ".named" do
    subject { model }

    let(:name1) { 'foo1' }
    let(:name2) { 'foo2' }

    before do
      subject.create(name: name1)
      subject.create(name: name2)
    end

    it "must be able to find resources with similar names" do
      resources = subject.named('foo')

      expect(resources.length).to eq(2)
      expect(resources[0].name).to be == name1
      expect(resources[1].name).to be == name2
    end

    after { subject.destroy_all }
  end

  describe ".with_name" do
    subject { model }

    let(:name1) { 'foo1' }
    let(:name2) { 'foo2' }
    let(:name3) { 'foo3' }

    before do
      subject.create(name: name1)
      subject.create(name: name2)
      subject.create(name: name3)
    end

    it "must be able to find resources with the matching name" do
      records = subject.with_name(name2)

      expect(records.length).to eq(1)
      expect(records[0].name).to be == name2
    end

    after { subject.destroy_all }
  end
end
