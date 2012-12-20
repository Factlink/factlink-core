require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/sub_comments/index_for_comment'

describe Interactors::SubComments::IndexForComment do
  include PavlovSupport
  before do
    stub_classes 'SubComment', 'Comment', 'KillObject'
  end

  it 'initializes correctly' do
    interactor = Interactors::SubComments::IndexForComment.new '2a', current_user: mock

    expect( interactor ).to_not be_nil
  end

  it '.authorized denied when no user is given' do
    expect{ Interactors::SubComments::IndexForComment.new '2a', current_user: nil }.
      to raise_error Pavlov::AccessDenied, 'Unauthorized'
  end

  describe '.validate' do
    let(:subject_class) { Interactors::SubComments::IndexForComment }

    it 'without comment_id doesn''t validate' do
      expect_validating(nil, current_user: mock).
        to fail_validation('comment_id should be an hexadecimal string.')
    end
  end

  describe '.execute' do
    before do
      stub_classes 'Queries::SubComments::Index'
    end

    it do
      comment_id = '2b'
      user = mock
      sub_comments = [mock, mock]
      dead_sub_comments = [mock, mock]
      authorities = [10, 20]

      interactor = Interactors::SubComments::IndexForComment.new comment_id, current_user: user
      should_receive_new_with_and_receive_call(Queries::SubComments::Index, comment_id, 'Comment', current_user: user).
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
  end

  describe '.top_fact' do
    it 'returns the top fact for the comment_id' do
      comment_id = '2a'
      fact = mock
      comment = mock(fact_data: mock(fact:fact))
      Comment.should_receive(:find).with(comment_id).and_return(comment)

      interactor = Interactors::SubComments::IndexForComment.new comment_id, current_user: mock

      result = interactor.top_fact

      result.should eq fact
    end

    it 'caches the fact' do
      comment_id = '2a'
      fact = mock
      comment = mock(fact_data: mock(fact:fact))
      Comment.should_receive(:find).with(comment_id).and_return(comment)

      interactor = Interactors::SubComments::IndexForComment.new comment_id, current_user: mock

      result = interactor.top_fact

      result2 = interactor.top_fact

      result2.should eq fact
    end
  end

  describe '.authority_of_user_who_created' do
    before do
      stub_classes 'Queries::AuthorityOnFactFor'
    end

    it 'retrieves the authority and kills the subcomment' do
      comment_id = '2a'
      fact = mock
      graph_user = mock
      authority = mock
      user = mock
      sub_comment = mock(created_by: mock(graph_user: graph_user))
      interactor = Interactors::SubComments::IndexForComment.new comment_id, current_user: user

      interactor.should_receive(:top_fact).and_return(fact)
      should_receive_new_with_and_receive_call(Queries::AuthorityOnFactFor, fact, graph_user, current_user: user).
        and_return authority

      result = interactor.authority_of_user_who_created sub_comment

      expect(result).to eq authority
    end
  end
end
