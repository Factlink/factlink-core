require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/groups/create'

describe Interactors::Groups::Create do
  include PavlovSupport
  before do
    stub_classes 'User'
  end

  describe '#validate' do
    it 'allows minimal legal input' do
      interactor = described_class.new groupname: 'name',
                                       members: [],
                                       pavlov_options: {}

      expect(interactor.valid?).to eq(true)
    end
    it 'verifies members is present' do
      interactor = described_class.new groupname: 'name',
                                       pavlov_options: {}

      expect(interactor.valid?).to eq(false)
    end
    it 'verifies members is not nil' do
      interactor = described_class.new groupname: 'name',
                                       members: nil,
                                       pavlov_options: {}

      expect(interactor.valid?).to eq(false)
    end
    it 'verifies members is not a string' do
      interactor = described_class.new groupname: 'name',
                                       members: "asd",
                                       pavlov_options: {}

      expect(interactor.valid?).to eq(false)
    end
    it 'verifies members is not a hash' do
      interactor = described_class.new groupname: 'name',
                                       members: {},
                                       pavlov_options: {}

      expect(interactor.valid?).to eq(false)
    end
    it 'verifies members is not an array of hash' do
      interactor = described_class.new groupname: 'name',
                                       members: [{}],
                                       pavlov_options: {}

      expect(interactor.valid?).to eq(false)
    end
    it 'verifies members is not a mixed array' do
      interactor = described_class.new groupname: 'name',
                                       members: ["asd", []],
                                       pavlov_options: {}

      expect(interactor.valid?).to eq(false)
    end
  end
end
