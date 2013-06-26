require 'spec_helper'

describe 'fact' do
  include PavlovSupport

  let(:current_user) { create :active_user }

  it 'can be created' do
    as(current_user) do |pavlov|
      displaystring = 'displaystring'

      fact = pavlov.interactor :'facts/create', displaystring, '', '', {}

      result = pavlov.interactor :'facts/get', fact.id

      expect(result.data.displaystring).to eq displaystring
    end
  end

end
