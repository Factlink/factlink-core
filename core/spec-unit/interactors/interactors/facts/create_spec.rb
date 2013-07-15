require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/facts/create.rb'

describe Interactors::Facts::Create do
  include PavlovSupport

  before do
    stub_classes 'Fact', 'Blacklist'
  end

  describe '.validate' do
    it 'calls the correct validation methods' do
      displaystring = 'displaystring'
      url = 'url'
      title = 'title'
      sharing_options = {}

      described_class.any_instance.should_receive(:validate_nonempty_string)
                                  .with(:displaystring, displaystring)
      described_class.any_instance.should_receive(:validate_string)
                                  .with(:url, url)
      described_class.any_instance.should_receive(:validate_string)
                                  .with(:title, title)
      described_class.any_instance.should_receive(:validate_not_nil)
                                  .with(:sharing_options, sharing_options)

      described_class.new displaystring, url, title, sharing_options, ability: mock(can?: true)
    end
  end

  it '.authorized raises when not able to create facts' do
    expect{ described_class.new 'displaystring', 'url', 'title', mock, ability: mock(can?: false) }.
      to raise_error Pavlov::AccessDenied, "Unauthorized"
  end

  describe '#call' do
    it 'correctly when site doesn''t exist' do
      url = 'www.fmf.nl'
      displaystring = 'this is the annotated text'
      title = 'this is the title'
      site = mock
      fact_data = mock(persisted?: true)
      fact = mock(id: '1', errors: [], data: fact_data)
      user = mock(id: '123abc')
      sharing_options = {}
      Blacklist.stub default: mock
      Blacklist.default.stub(:matches?).with(url).and_return false

      pavlov_options = {current_user: user, ability: mock(can?: true)}
      interactor = described_class.new displaystring, url, title, sharing_options, pavlov_options

      Pavlov.stub(:query)
            .with(:'sites/for_url', url, pavlov_options)
            .and_return(nil)

      Pavlov.should_receive(:command)
            .with(:'sites/create', url, pavlov_options)
            .and_return(site)

      Pavlov.should_receive(:command)
            .with(:'facts/create', displaystring, title, user, site, pavlov_options)
            .and_return(fact)

      Pavlov.should_receive(:command)
            .with(:'facts/share_new', fact.id.to_s, sharing_options, pavlov_options)

      Pavlov.should_receive(:command)
            .with(:'facts/add_to_recently_viewed', fact.id.to_i, user.id.to_s, pavlov_options)

      expect(interactor.call).to eq fact
    end

    it 'correctly when site exists' do
      url = 'www.fmf.nl'
      displaystring = 'this is the annotated text'
      title = 'this is the title'
      site = mock
      fact_data = mock(persisted?: true)
      fact = mock(id: '1', errors: [], data: fact_data)
      user = mock(id: '123abc')
      sharing_options = mock
      Blacklist.stub default: mock
      Blacklist.default.stub(:matches?).with(url).and_return false

      pavlov_options = {current_user: user, ability: mock(can?: true)}
      interactor = described_class.new displaystring, url, title, sharing_options, pavlov_options

      Pavlov.stub(:query)
            .with(:'sites/for_url',url, pavlov_options)
            .and_return(site)

      Pavlov.should_receive(:command)
            .with(:'facts/create', displaystring, title, user, site, pavlov_options)
            .and_return(fact)

      Pavlov.should_receive(:command)
            .with(:'facts/share_new', fact.id.to_s, sharing_options, pavlov_options)

      Pavlov.should_receive(:command)
            .with(:'facts/add_to_recently_viewed', fact.id.to_i, user.id.to_s, pavlov_options)


      expect(interactor.call).to eq fact
    end
    it 'creates nor retrieves a site for a blacklisted url' do
      url = 'www.fmf.nl'
      displaystring = 'this is the annotated text'
      title = 'this is the title'
      fact_data = mock(persisted?: true)
      fact = mock(id: '1', errors: [], data: fact_data)
      user = mock(id: '123abc')
      sharing_options = mock
      Blacklist.stub default: mock
      Blacklist.default.stub(:matches?).with(url).and_return true

      pavlov_options = {current_user: user, ability: mock(can?: true)}
      interactor = described_class.new displaystring, url, title, sharing_options, pavlov_options

      Pavlov.should_receive(:command)
            .with(:'facts/create', displaystring, title, user, nil, pavlov_options)
            .and_return(fact)

      Pavlov.should_receive(:command)
            .with(:'facts/share_new', fact.id.to_s, sharing_options, pavlov_options)

      Pavlov.should_receive(:command)
            .with(:'facts/add_to_recently_viewed', fact.id.to_i, user.id.to_s, pavlov_options)

      expect(interactor.call).to eq fact
    end
  end
end
