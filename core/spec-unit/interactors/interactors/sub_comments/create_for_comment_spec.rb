require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/sub_comments/create_for_comment'

describe Interactors::SubComments::CreateForComment do
  include PavlovSupport

  it 'initializes correctly' do
    interactor = Interactors::SubComments::CreateForComment.new '2a', 'hoi', current_user: mock

    expect( interactor ).to_not be_nil
  end

  it '.authorized denied when no user is given' do
    expect{ Interactors::SubComments::CreateForComment.new '2a', 'hoi', current_user: nil }.
      to raise_error Pavlov::AccessDenied, 'Unauthorized'
  end

  describe '.validate' do
    let(:subject_class) { Interactors::SubComments::CreateForComment }

    it 'without comment_id doesn''t validate' do
      expect_validating(nil, 'hoi', current_user: mock).
        to fail_validation('comment_id should be an hexadecimal string.')
    end

    it 'without content doesn''t validate' do
      expect_validating('2a', '', current_user: mock).
        to fail_validation('content should not be empty.')
    end
  end

  describe '.execute' do
    before do
      stub_classes 'KillObject', 'Commands::SubComments::CreateXxx'
    end

    it 'calls the corresponding command' do
      comment_id = '2a'
      user = mock
      sub_comment = mock
      authority = mock
      dead_sub_comment = mock
      content = 'hoi'
      interactor = Interactors::SubComments::CreateForComment.new comment_id, content, current_user: user

      should_receive_new_with_and_receive_call(Commands::SubComments::CreateXxx, comment_id, 'Comment', content, user, current_user: user).
        and_return(sub_comment)
      interactor.should_receive(:authority_of_user_who_created).with(sub_comment).
        and_return(authority)
      interactor.should_receive(:create_activity).with(sub_comment)
      KillObject.should_receive(:sub_comment).with(sub_comment, authority: authority).
        and_return(dead_sub_comment)

      result = interactor.execute

      expect(result).to eq dead_sub_comment
    end
  end

  describe '.top_fact' do

    before do
      stub_classes 'Comment'
    end
    it 'returns the top fact for the comment_id' do
      comment_id = '2a'
      fact = mock
      comment = mock(fact_data: mock(fact:fact))
      Comment.should_receive(:find).with(comment_id).and_return(comment)

      interactor = Interactors::SubComments::CreateForComment.new comment_id, 'hoi', current_user: mock

      result = interactor.top_fact

      result.should eq fact
    end

    it 'caches the fact' do
      comment_id = '2a'
      fact = mock
      comment = mock(fact_data: mock(fact:fact))
      Comment.should_receive(:find).with(comment_id).and_return(comment)

      interactor = Interactors::SubComments::CreateForComment.new comment_id, 'hoi', current_user: mock

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
      interactor = Interactors::SubComments::CreateForComment.new comment_id, 'hoi', current_user: user

      interactor.should_receive(:top_fact).and_return(fact)
      should_receive_new_with_and_receive_call(Queries::AuthorityOnFactFor, fact, graph_user, current_user: user).
        and_return authority

      result = interactor.authority_of_user_who_created sub_comment

      expect(result).to eq authority
    end
  end
end
