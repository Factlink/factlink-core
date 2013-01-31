require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/topics/facts'

describe Interactors::Topics::Facts do
  include PavlovSupport

  describe '#execute' do
    it 'correctly' do
      slug_title = 'slug-title'
      count = 10
      max_timestamp = 100
      interactor = described_class.new slug_title, count, max_timestamp, current_user: mock
      results = mock

      interactor.should_receive(:query).with(:'topics/facts', slug_title, count, max_timestamp).
        and_return(results)

      expect( interactor.execute ).to eq results
    end
  end

  describe 'authorized?' do
    it 'throws when no current_user' do
      expect { described_class.new '1a', 10, 100 }.
        to raise_error Pavlov::AccessDenied,'Unauthorized'
    end
  end

  describe '#setup_defaults' do
    it :count do
      default_count = 7
      slug_title = 'slug-title'
      max_timestamp = 100
      interactor = described_class.new slug_title, nil, max_timestamp, current_user: mock

      interactor.setup_defaults

      expect( interactor.count ).to eq default_count
    end
  end

  describe '#validation' do
    let(:subject_class) { described_class }

    it :slug_title do
      expect_validating(1, 100, 123).
        to fail_validation('slug_title should be a string.')
    end

    it :count do
      expect_validating('1e', 'q', 123).
        to fail_validation('count should be an integer.')
    end

    it :max_timestamp do
      expect_validating('1e', 100, 'q').
        to fail_validation('max_timestamp should be an integer.')
    end
  end
end
