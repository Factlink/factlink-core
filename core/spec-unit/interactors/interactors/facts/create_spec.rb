require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/facts/create.rb'

describe Interactors::Facts::Create do
  include PavlovSupport

  it '.new' do
    interactor = Interactors::Facts::Create.new 'displaystring','url','title', current_user: mock
    interactor.should_not be_nil
  end

  describe '.validate' do
    let(:subject_class) { Interactors::Facts::Create }

    it 'requires displaystring to be a nonempty string' do
      expect_validating('', 'url', 'title').
        to fail_validation('displaystring should be a nonempty string.')
    end

    it 'requires url to be a string' do
      expect_validating('displaystring', 3, 'title').
        to fail_validation('url should be a string.')
    end

    it 'requires title to be a string' do
      expect_validating('displaystring', 'url', 1).
        to fail_validation('title should be a string.')
    end
  end

  it '.authorized raises when not logged in' do
    expect{ Interactors::Facts::Create.new 'displaystring', 'url', 'title', current_user: nil }.
      to raise_error Pavlov::AccessDenied, "Unauthorized"
  end

  describe '.execute' do
    it 'correctly when site doesn''t exist' do
      url = 'www.fmf.nl'
      displaystring = 'this is the annotated text'
      title = 'this is the title'
      site = mock
      fact = mock
      user = mock
      interactor = Interactors::Facts::Create.new displaystring, url, title, current_user: user

      interactor.should_receive(:query).with(:'sites/for_url', url).and_return(nil)
      interactor.should_receive(:command).with(:'sites/create', url).and_return(site)
      interactor.should_receive(:command).with(:'facts/create', displaystring, title, user, site).and_return(fact)

      expect(interactor.execute).to eq fact
    end

    it 'correctly when site exists' do
      url = 'www.fmf.nl'
      displaystring = 'this is the annotated text'
      title = 'this is the title'
      site = mock
      fact = mock
      user = mock
      interactor = Interactors::Facts::Create.new displaystring, url, title, current_user: user

      interactor.should_receive(:query).with(:'sites/for_url',url).and_return(site)
      interactor.should_receive(:command).with(:'facts/create', displaystring, title, user, site).and_return(fact)

      expect(interactor.execute).to eq fact
    end
  end
end
