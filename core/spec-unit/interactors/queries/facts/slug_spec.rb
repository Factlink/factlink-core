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
end
