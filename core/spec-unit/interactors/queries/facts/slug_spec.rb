require 'pavlov_helper'
require_relative '../../../../app/helpers/fact_helper.rb'
require_relative '../../../../app/interactors/queries/facts/slug.rb'

describe Queries::Facts::Slug do
  include PavlovSupport

  describe '#call' do
    it "sluggifies" do
      fact = mock(id: "1", to_s: 'Bla Bla')

      query = described_class.new fact, nil

      expect(query.call).to eq "bla-bla"
    end

    it "falls back to id on empty displaystring" do
      fact = mock(id: "1", to_s: '')

      query = described_class.new fact, nil

      expect(query.call).to eq "1"
    end

    it "should have a maximum length" do
      max_slug_length = 5
      fact = mock(id: "1", to_s: 'Bla Bla')

      query = described_class.new fact, max_slug_length

      expect(query.call).to eq "bla-b"
    end
  end

  describe '#validate' do
    it 'calls the correct validation methods' do
      fact = double

      described_class.any_instance.should_receive(:validate_not_nil)
        .with(:fact, fact)

      interactor = described_class.new fact, nil
    end

    it 'checks max_slug_length if it is set' do
      fact = double
      max_slug_length = 10

      described_class.any_instance.should_receive(:validate_integer)
        .with(:max_slug_length, max_slug_length)

      interactor = described_class.new fact, max_slug_length
    end
  end
end
