require 'spec_helper'

describe 'global_features' do
  include PavlovSupport

  let(:current_user) do
    OpenStruct.new(
      agrees_tos: true,
      admin?: true,
      features: [],
    )
  end

  it 'initial state is empty' do
    as(current_user) do |pavlov|
      features = pavlov.interactor :'global_features/all'
      expect(features).to eq []
    end
  end

  it 'retains set features' do
    as(current_user) do |pavlov|
      features = [ "foo", "bar" ]
      pavlov.interactor :'global_features/set', features
      read_features = pavlov.interactor :'global_features/all'
      expect(read_features.to_set).to eq features.to_set
    end
  end

  it 'removes previously set features on a new set' do
    as(current_user) do |pavlov|
      features = [ "foo", "bar" ]
      new_features = [ "foobar" ]
      pavlov.interactor :'global_features/set', features
      pavlov.interactor :'global_features/set', new_features
      read_features = pavlov.interactor :'global_features/all'
      expect(read_features.to_set).to eq new_features.to_set
    end
  end
end
