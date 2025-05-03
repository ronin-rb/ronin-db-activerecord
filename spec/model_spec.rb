require 'spec_helper'
require 'ronin/db/model'

describe Ronin::DB::Model do
  class TestModel < ActiveRecord::Base
    include Ronin::DB::Model

    self.table_name = 'test_model'
  end

  let(:model) { TestModel }

  before(:all) do
    ActiveRecord::Base.connection.create_table :test_model
  end

  describe ".included" do
    subject { model }

    it "must set .table_name_prefix to 'ronin_'" do
      expect(subject.table_name_prefix).to eq('ronin_')
    end
  end
end
