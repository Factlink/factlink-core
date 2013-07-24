require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/facts/create.rb'

describe Interactors::Facts::Create do
  include PavlovSupport

  before do
    stub_classes 'Fact', 'Blacklist'
  end

  describe 'validation' do
    it 'requires displaystring to be a nonempty string' do
      hash = { displaystring: '', url: 'u', title: 't', sharing_options: 'a' }
      expect_validating(hash)
        .to fail_validation('displaystring should be a nonempty string.')
    end

    it 'requires title to be a string' do
      hash = { displaystring: 'ds', url: 'u', title: 4, sharing_options: 'a' }
      expect_validating(hash)
        .to fail_validation('title should be a string.')
    end

    it 'requires url to be a string' do
      hash = { displaystring: 'ds', url: 6, title: 't', sharing_options: 'a' }
      expect_validating(hash)
        .to fail_validation('url should be a string.')
    end
  end

  it '.authorized raises when not able to create facts' do
    ability = mock
    ability.stub(:can?)
             .with(:create, Fact)
             .and_return(false)

    interactor = described_class.new displaystring: 'displaystring', url: 'url',
      title: 'title', sharing_options: mock, pavlov_options: { ability:ability }

    expect { interactor.call }
      .to raise_error Pavlov::AccessDenied, "Unauthorized"
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

      pavlov_options = { current_user: user, ability: mock(can?: true) }
      interactor = described_class.new displaystring: displaystring, url: url,
        title: title, sharing_options: sharing_options,
        pavlov_options: pavlov_options

      Pavlov.stub(:old_query)
            .with(:'sites/for_url', url, pavlov_options)
            .and_return(nil)

      Pavlov.should_receive(:old_command)
            .with(:'sites/create', url, pavlov_options)
            .and_return(site)

      Pavlov.should_receive(:old_command)
            .with(:'facts/create', displaystring, title, user, site, pavlov_options)
            .and_return(fact)

      Pavlov.should_receive(:old_command)
            .with(:'facts/share_new', fact.id.to_s, sharing_options, pavlov_options)

      Pavlov.should_receive(:old_command)
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

      pavlov_options = { current_user: user, ability: mock(can?: true) }
      interactor = described_class.new displaystring: displaystring, url: url,
        title: title, sharing_options: sharing_options,
        pavlov_options: pavlov_options

      Pavlov.stub(:old_query)
            .with(:'sites/for_url',url, pavlov_options)
            .and_return(site)

      Pavlov.should_receive(:old_command)
            .with(:'facts/create', displaystring, title, user, site, pavlov_options)
            .and_return(fact)

      Pavlov.should_receive(:old_command)
            .with(:'facts/share_new', fact.id.to_s, sharing_options, pavlov_options)

      Pavlov.should_receive(:old_command)
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

      pavlov_options = { current_user: user, ability: mock(can?: true) }
      interactor = described_class.new displaystring: displaystring, url: url,
        title: title, sharing_options: sharing_options,
        pavlov_options: pavlov_options

      Pavlov.should_receive(:old_command)
            .with(:'facts/create', displaystring, title, user, nil, pavlov_options)
            .and_return(fact)

      Pavlov.should_receive(:old_command)
            .with(:'facts/share_new', fact.id.to_s, sharing_options, pavlov_options)

      Pavlov.should_receive(:old_command)
            .with(:'facts/add_to_recently_viewed', fact.id.to_i, user.id.to_s, pavlov_options)

      expect(interactor.call).to eq fact
    end
  end
end
