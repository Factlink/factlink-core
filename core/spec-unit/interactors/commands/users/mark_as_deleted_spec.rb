require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/users/mark_as_deleted'

describe Commands::Users::MarkAsDeleted do
  include PavlovSupport
  before { stub_classes 'User' }

  describe "#validate" do
    it "requires a non-nil user" do
      expect_validating(user:nil).to fail_validation
    end

    it "does not accept a user of type String" do
      expect_validating(user: "123").to fail_validation
    end

    it "does not accept a user of type Fixnum" do
      expect_validating(user: 123).to fail_validation
    end

    it "accepts a user of type User" do
      user = User.new
      expect_validating(user: user)
    end
  end

  describe "#call" do
    it "marks the user as deleted" do

      user = User.new

      command = described_class.new user: user

      expect(user).to receive(:deleted=).with(true).ordered
      expect(user).to receive(:save!).ordered

      command.call
    end
  end
end
