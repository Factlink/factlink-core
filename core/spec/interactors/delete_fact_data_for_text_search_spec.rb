require_relative 'interactor_spec_helper'
require File.expand_path('../../../app/interactors/delete_fact_data_for_text_search.rb', __FILE__)

describe DeleteFactDataForTextSearch do
  def fake_class
    Class.new
  end

  let(:fact_data) do
    fact_data = stub()
    fact_data.stub id: 1
    fact_data
  end

  before do
    stub_const('HTTParty', fake_class)
    stub_const('FactlinkUI::Application', fake_class)
  end

  it 'intitializes' do
    interactor = DeleteFactDataForTextSearch.new fact_data

    interactor.should_not be_nil
  end

  it 'raises when fact_data is not a FactData' do
    expect { interactor = DeleteFactDataForTextSearch.new 'FactData' }.
      to raise_error(RuntimeError, 'factdata missing fields ([:id]).')
  end

  describe '.execute' do
    it 'correctly' do
      url = 'localhost:9200'
      config = mock()
      config.stub elasticsearch_url: url
      FactlinkUI::Application.stub config: config

      HTTParty.should_receive(:delete).with("http://#{url}/factdata/#{fact_data.id}")
      interactor = DeleteFactDataForTextSearch.new fact_data

      interactor.execute
    end
  end

end

