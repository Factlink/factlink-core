require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/users/mark_as_deleted'

describe Commands::Users::MarkAsDeleted do
  include PavlovSupport

  describe "#validate" do
    before { stub_classes 'User' }

    it "requires a non-nil user" do
      command = described_class.new user: nil
      expect{command.validate}.to raise_error(Pavlov::ValidationError)
    end

    it "does not accept a user of type String" do
      command = described_class.new user: "123"
      expect{command.validate}.to raise_error(Pavlov::ValidationError)
    end

    it "does not accept a user of type Fixnum" do
      command = described_class.new user: 123
      expect{command.validate}.to raise_error(Pavlov::ValidationError)
    end

    it "accepts a user of type User" do
      user = User.new
      command = described_class.new user: user
      command.validate
    end
  end


  describe "#execute" do
    before { stub_classes 'User' }

    it "marks the user as deleted" do

      user = User.new
      command = described_class.new user: user

      expect(user).to receive(:deleted=).with(true).once
      expect(user).to receive(:save).once.and_return(true)

      command.execute
    end
  end
end
