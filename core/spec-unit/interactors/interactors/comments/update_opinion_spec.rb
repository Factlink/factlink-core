require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/comments/update_opinion.rb'


describe Interactors::Comments::UpdateOpinion do
  include PavlovSupport

  # it 'initializes correctly' do
  #   user = double
  #   interactor = described_class.new comment_id: '1', opinion: 'believes',
  #     pavlov_options: { current_user: user }
  #   interactor.should_not be_nil
  # end

  # it 'without current user gives an unauthorized exception' do
  #   expect_validating( comment_id: '1', opinion: 'believes' )
  #     .to raise_error(Pavlov::AccessDenied, 'Unauthorized')
  # end

  # it 'with a invalid comment_id doesn\'t validate' do
  #   expect_validating( comment_id: 'g', opinion: 'believes' )
  #     .to fail_validation 'comment_id should be an hexadecimal string.'
  # end

  # it 'with a invalid opinion doesn\'t validate' do
  #   expect_validating( comment_id: '1', opinion: 'dunno')
  #     .to fail_validation 'opinion should be on of these values: ["believes", "disbelieves", "doubts", nil].'
  # end

  describe '#call' do
    before do
      stub_classes 'Commands::Comments::SetOpinion'
    end

    it 'call the set_opinion command when an opinion is being set' do
      opinion = 'believes'
      user = mock(graph_user: mock)
      comment = mock(id: '123')
      pavlov_options = {current_user: user}

      interactor = described_class.new comment_id: comment.id, opinion: opinion,
        pavlov_options: { current_user: user }

      Pavlov.stub(:old_query)
        .with(:'comments/get', comment.id, pavlov_options).and_return(comment)
      Pavlov.should_receive(:old_command)
        .with(:'comments/set_opinion', comment.id, opinion, user.graph_user, pavlov_options)
      Pavlov.should_receive(:old_command)
        .with(:'opinions/recalculate_comment_user_opinion', comment, pavlov_options)

      expect(interactor.call).to eq comment
    end

    it 'calls the remove_opinion command when no opinion is passed' do
      user = mock(graph_user: mock)
      comment = mock(id: '123')
      pavlov_options = {current_user: user}
      interactor = described_class.new comment_id: comment.id, opinion: nil,
                                       pavlov_options: pavlov_options

      Pavlov.stub(:old_query).with(:'comments/get', comment.id, pavlov_options).and_return(comment)

      Pavlov.should_receive(:old_command)
        .with(:'comments/remove_opinion', comment.id, user.graph_user, pavlov_options)
      Pavlov.should_receive(:old_command)
        .with(:'opinions/recalculate_comment_user_opinion', comment, pavlov_options)

      expect(interactor.call).to eq comment
    end

    it 'refreshes the comment after calling recalculate_comment_user_opinion' do
      opinion = 'believes'
      user = mock(graph_user: mock)
      pavlov_options = {current_user: user}

      comment = mock(id: 'abc')
      updated_comment = double

      interactor = described_class.new comment_id: comment.id, opinion: opinion,
        pavlov_options: { current_user: user }

      Pavlov.stub(:old_query)
        .with(:'comments/get', comment.id, pavlov_options).and_return(comment)
      Pavlov.stub(:old_command)
        .with(:'comments/set_opinion', comment.id, opinion, user.graph_user, pavlov_options)
      Pavlov.stub(:old_command)
        .with(:'opinions/recalculate_comment_user_opinion', comment, pavlov_options) do
          Pavlov.stub(:old_query)
            .with(:'comments/get', comment.id, pavlov_options).and_return(updated_comment)
      end

      expect(interactor.call).to eq updated_comment
    end
  end
end
