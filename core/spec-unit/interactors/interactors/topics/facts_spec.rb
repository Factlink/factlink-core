require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/topics/facts'

describe Interactors::Topics::Facts do
  include PavlovSupport

  describe '#call' do
    it 'correctly' do
      slug_title = 'slug-title'
      count = 10
      max_timestamp = 100
      results = double

      pavlov_options = {current_user: double}
      interactor = described_class.new(slug_title: slug_title, count: count, max_timestamp: max_timestamp, pavlov_options: pavlov_options)

      Pavlov.stub(:query)
            .with(:'topics/facts',
                      slug_title: slug_title, count: count,
                      max_timestamp: max_timestamp, pavlov_options: pavlov_options)
            .and_return(results)

      expect( interactor.call ).to eq results
    end
  end

  describe 'authorized?' do
    it 'throws when no current_user' do
      expect { described_class.new(slug_title: '1a', count: 10, max_timestamp: 100).call }
        .to raise_error(Pavlov::AccessDenied, 'Unauthorized')
    end
  end

  describe '#setup_defaults' do
    it :count do
      default_count = 7
      slug_title = 'slug-title'
      max_timestamp = 100
      interactor = described_class.new(slug_title: slug_title, count: nil,
        max_timestamp: max_timestamp, pavlov_options: { current_user: double })

      interactor.setup_defaults

      expect( interactor.count ).to eq default_count
    end
  end

  describe 'validations' do
    it :slug_title do
      expect_validating(slug_title: 1, count: 100, max_timestamp: 123)
        .to fail_validation('slug_title should be a string.')
    end

    it :count do
      expect_validating(slug_title: '1e', count: 'q', max_timestamp: 123)
        .to fail_validation('count should be an integer.')
    end

    it :max_timestamp do
      expect_validating(slug_title: '1e', count: 100, max_timestamp: 'q')
        .to fail_validation('max_timestamp should be an integer.')
    end
  end
end
