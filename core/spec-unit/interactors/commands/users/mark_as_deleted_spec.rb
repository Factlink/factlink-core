require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/users/mark_as_deleted'

describe Commands::User::MarkAsDeleted do
  include PavlovSupport

  describe "#validate" do
    it "requires a non-nil user" do
      command = described_class.new user: nil
      expect(command.validate).to eq(false)
    end

    it "does not accept a user of type String" do
      command = described_class.new user: "123"
      expect(command.validate).to eq(false)
    end

    it "does not accept a user of type Fixnum" do
      command = described_class.new user: 123
      expect(command.validate).to eq(false)
    end

    it "accepts a user of type User" do
      stub_classes 'User'
      user = User.new
      command = described_class.new user: user
      expect(command.validate).to eq(true)
    end
  end
end
