require 'pavlov_helper'
require 'active_support/core_ext/object/blank'
require 'active_support/inflector'

require_relative '../../../../app/helpers/fact_helper.rb'
require_relative '../../../../app/interactors/queries/facts/slug.rb'

describe Queries::Facts::Slug do
  include PavlovSupport

  describe '#call' do
    it "sluggifies" do
      fact = double(id: "1", to_s: 'Bla Bla')

      query = described_class.new fact: fact, max_slug_length_in: nil

      expect(query.call).to eq "bla-bla"
    end

    it "falls back to id on empty displaystring" do
      fact = double(id: "1", to_s: '')

      query = described_class.new fact: fact, max_slug_length_in: nil

      expect(query.call).to eq "1"
    end

    it "should have a maximum length" do
      max_slug_length = 5
      fact = double(id: "1", to_s: 'Bla Bla')

      query = described_class.new fact: fact, max_slug_length_in: max_slug_length

      expect(query.call).to eq "bla-b"
    end
  end

  describe '#validate' do
    it 'validates that fact is not nil' do
      expect_validating(fact: nil, max_slug_length_in: nil)
        .to fail_validation 'fact should not be nil.'
    end

    it 'check that max_slug_length is a number if it is set' do
      expect_validating(fact: double, max_slug_length_in: 'a')
        .to fail_validation 'max_slug_length should be an integer.'
    end
  end
end
