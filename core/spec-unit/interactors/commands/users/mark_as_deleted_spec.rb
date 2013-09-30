require 'pavlov_helper'
require_relative '../../../../app/interactors/commands/users/mark_as_deleted'

describe Commands::Users::MarkAsDeleted do
  include PavlovSupport

  describe "#call" do
    it "marks the user as deleted" do

      user = double

      command = described_class.new user: user

      expect(user).to receive(:deleted=).with(true).ordered
      expect(user).to receive(:save!).ordered

      command.call
    end
  end
end
