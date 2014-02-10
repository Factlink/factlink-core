require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/comments/update_opinion.rb'


describe Interactors::Comments::UpdateOpinion do
  include PavlovSupport

  it 'without current user gives an unauthorized exception' do
    expect do
      interactor = described_class.new(comment_id: '1', opinion: 'believes' )
      interactor.call
    end.to raise_error(Pavlov::AccessDenied, 'Unauthorized')
  end

  it 'with a invalid comment_id doesn\'t validate' do
    expect_validating(comment_id: 'g', opinion: 'believes' )
      .to fail_validation 'comment_id should be an hexadecimal string.'
  end

  it 'with a invalid opinion doesn\'t validate' do
    expect_validating(comment_id: '1', opinion: 'dunno')
      .to fail_validation 'opinion should be on of these values: ["believes", "disbelieves", "doubts", "no_vote"].'
  end

  describe '#call' do
    before do
      stub_classes 'Commands::Comments::SetOpinion'
    end

    it 'call the set_opinion command when an opinion is being set' do
      opinion = 'believes'
      user = double(graph_user: double)
      comment = double(id: '123')
      pavlov_options = { current_user: user }

      interactor = described_class.new comment_id: comment.id, opinion: opinion,
                                       pavlov_options: { current_user: user }

      Pavlov.stub(:query)
            .with(:'comments/by_ids',
                      ids: comment.id, pavlov_options: pavlov_options)
            .and_return([comment])


      expect(Backend::Comments).to receive(:set_opinion)
        .with(comment_id: comment.id, opinion: opinion, graph_user: user.graph_user)

      expect(interactor.call).to eq comment
    end

    it 'calls the remove_opinion command when no_vote is passed' do
      user = double(graph_user: double)
      comment = double(id: '123')
      pavlov_options = {current_user: user}
      interactor = described_class.new comment_id: comment.id, opinion: 'no_vote',
                                       pavlov_options: pavlov_options

      Pavlov.stub(:query)
            .with(:'comments/by_ids',
                      ids: comment.id, pavlov_options: pavlov_options)
            .and_return([comment])

      expect(Backend::Comments).to receive(:remove_opinion)
        .with(comment_id: comment.id, graph_user: user.graph_user)

      expect(interactor.call).to eq comment
    end

    it 'refreshes the comment after setting the opinion' do
      opinion = 'believes'
      user = double(graph_user: double)
      pavlov_options = {current_user: user}

      comment = double(id: 'abc')
      updated_comment = double

      interactor = described_class.new comment_id: comment.id, opinion: opinion,
                                       pavlov_options: { current_user: user }

      Pavlov.stub(:query)
            .with(:'comments/by_ids',
                      ids: comment.id, pavlov_options: pavlov_options)
            .and_return([comment])
      allow(Backend::Comments).to receive(:set_opinion)
        .with(comment_id: comment.id, opinion: opinion, graph_user: user.graph_user) do
        Pavlov.stub(:query)
              .with(:'comments/by_ids',
                        ids: comment.id, pavlov_options: pavlov_options)
              .and_return([updated_comment])
      end

      expect(interactor.call).to eq updated_comment
    end
  end
end
