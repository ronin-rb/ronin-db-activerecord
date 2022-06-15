require 'spec_helper'
require 'ronin/db/migrations'

describe Ronin::DB::Migrations do
  let(:migration_context) { subject.send(:context) }

  describe ".current_version" do
    it "must call .current_version on the MigrationContext object" do
      expect(migration_context).to receive(:current_version)

      subject.current_version
    end
  end

  describe ".needs_migration?" do
    it "must call .needs_migration? on the MigrationContext object" do
      expect(migration_context).to receive(:needs_migration?)

      subject.needs_migration?
    end
  end

  describe ".migrate" do
    context "when called with no arguments" do
      it "must call .migrate(nil) on the MigrationContext object" do
        expect(migration_context).to receive(:migrate).with(nil)

        subject.migrate
      end
    end

    context "when given a target version" do
      let(:target_version) { 42 }

      it "must call .migrate(target_version) on the MigrationContext object" do
        expect(migration_context).to receive(:migrate).with(target_version)

        subject.migrate(target_version)
      end
    end
  end

  describe ".up" do
    context "when called with no arguments" do
      it "must call .up(nil) on the MigrationContext object" do
        expect(migration_context).to receive(:up).with(nil)

        subject.up
      end
    end

    context "when given a target version" do
      let(:target_version) { 42 }

      it "must call .up(target_version) on the MigrationContext object" do
        expect(migration_context).to receive(:up).with(target_version)

        subject.up(target_version)
      end
    end
  end

  describe ".down" do
    context "when called with no arguments" do
      it "must call .down(nil) on the MigrationContext object" do
        expect(migration_context).to receive(:down).with(nil)

        subject.down
      end
    end

    context "when given a target version" do
      let(:target_version) { 42 }

      it "must call .down(target_version) on the MigrationContext object" do
        expect(migration_context).to receive(:down).with(target_version)

        subject.down(target_version)
      end
    end
  end

  describe ".rollback" do
    context "when called with no arguments" do
      it "must call .rollback(1) on the MigrationContext object" do
        expect(migration_context).to receive(:rollback).with(1)

        subject.rollback
      end
    end

    context "when given a target version" do
      let(:steps) { 2 }

      it "must call .rollback(steps) on the MigrationContext object" do
        expect(migration_context).to receive(:rollback).with(steps)

        subject.rollback(steps)
      end
    end
  end

  describe ".foreward" do
    context "when called with no arguments" do
      it "must call .foreward(1) on the MigrationContext object" do
        expect(migration_context).to receive(:foreward).with(1)

        subject.foreward
      end
    end

    context "when given a target version" do
      let(:steps) { 2 }

      it "must call .foreward(steps) on the MigrationContext object" do
        expect(migration_context).to receive(:foreward).with(steps)

        subject.foreward(steps)
      end
    end
  end
end
