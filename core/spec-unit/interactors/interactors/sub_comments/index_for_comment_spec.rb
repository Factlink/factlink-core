require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/sub_comments/index_for_comment'

describe Interactors::SubComments::IndexForComment do
  include PavlovSupport
  before do
    stub_classes 'SubComment', 'Comment', 'KillObject',
                 'Queries::SubComments::Index'
  end

  describe '.authorized' do
    it 'checks if the comment can be shown' do
      comment_id = '1a'
      comment = double

      Comment.stub(:find).with(comment_id).and_return(comment)

      ability = double
      ability.should_receive(:can?).with(:show, comment).and_return(false)

      expect do
        interactor = described_class.new comment_id, ability: ability
      end.to raise_error(Pavlov::AccessDenied)
    end
  end

  describe '.validate' do
    it 'without comment_id doesn''t validate' do
      expect_validating(nil).
        to fail_validation('comment_id should be an hexadecimal string.')
    end
  end

  describe '.execute' do
    it do
      comment_id = '2b'
      sub_comments = [mock, mock]
      dead_sub_comments = [mock, mock]
      authorities = [10, 20]

      options = {ability: mock(can?: true)}

      Comment.stub(:find).with(comment_id)
             .and_return(mock)

      interactor = described_class.new comment_id, options

      interactor.should_receive(:old_query).with(:"sub_comments/index", comment_id, 'Comment').
        and_return(sub_comments)

      interactor.should_receive(:authority_of_user_who_created).
        with(sub_comments[0]).
        and_return(authorities[0])
      interactor.should_receive(:authority_of_user_who_created).
        with(sub_comments[1]).
        and_return(authorities[1])

      KillObject.should_receive(:sub_comment).
        with(sub_comments[0], authority: authorities[0]).
        and_return(dead_sub_comments[0])
      KillObject.should_receive(:sub_comment).
        with(sub_comments[1], authority: authorities[1]).
        and_return(dead_sub_comments[1])

      results = interactor.execute

      expect( results ).to eq dead_sub_comments
    end

    it 'throws an error when the comment does not exist' do
      stub_const 'Pavlov::ValidationError', RuntimeError

      options = {ability: mock(can?: true)}

      Comment.stub(:find).with('2b')
             .and_return(nil)

      interactor = described_class.new '2b', options

      expect{interactor.call}.to raise_error(Pavlov::ValidationError, "comment does not exist any more")
    end
  end

  describe '.top_fact' do
    before do
      described_class.any_instance.stub(:authorized?).and_return(true)
    end

    it 'returns the top fact for the comment_id' do
      comment_id = '2a'
      fact = double
      comment = mock(fact_data: mock(fact:fact))
      Comment.should_receive(:find).with(comment_id).and_return(comment)

      interactor = Interactors::SubComments::IndexForComment.new comment_id

      result = interactor.top_fact

      result.should eq fact
    end

    it 'caches the fact' do
      comment_id = '2a'
      fact = double
      comment = mock(fact_data: mock(fact:fact))
      Comment.should_receive(:find).with(comment_id).and_return(comment)

      interactor = Interactors::SubComments::IndexForComment.new comment_id

      result = interactor.top_fact

      result2 = interactor.top_fact

      result2.should eq fact
    end
  end

  describe '.authority_of_user_who_created' do
    before do
      stub_classes 'Queries::AuthorityOnFactFor'
      described_class.any_instance.stub(:authorized?).and_return(true)
    end

    it 'retrieves the authority and kills the subcomment' do
      comment_id = '2a'
      fact = double
      graph_user = double
      authority = double
      sub_comment = mock(created_by: mock(graph_user: graph_user))
      interactor = Interactors::SubComments::IndexForComment.new comment_id

      interactor.should_receive(:top_fact).and_return(fact)
      interactor.should_receive(:old_query).with(:"authority_on_fact_for", fact, graph_user).
        and_return authority

      result = interactor.authority_of_user_who_created sub_comment

      expect(result).to eq authority
    end
  end
end
