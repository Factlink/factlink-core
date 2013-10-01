require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/sub_comments/create_for_comment'

describe Interactors::SubComments::CreateForComment do
  include PavlovSupport

  before do
    stub_classes 'Comment', 'SubComment', 'KillObject',
                 'Commands::SubComments::CreateXxx',
                 'Queries::AuthorityOnFactFor'
  end

  it '.authorized denied the user cannot show the comment' do
    comment = double
    ability = double
    ability.stub(:can?).with(:show, comment).and_return(false)
    Comment.should_receive(:find).and_return(comment)

    interactor = described_class.new comment_id: '2a', content: 'hoi',
        pavlov_options: { current_user: nil, ability: ability }

    expect { interactor.call }
     .to raise_error Pavlov::AccessDenied, 'Unauthorized'
  end

  describe '.validate' do
    it 'without comment_id doesn''t validate' do
      expect_validating(comment_id: nil, content: 'hoi')
        .to fail_validation('comment_id should be an hexadecimal string.')
    end

    it 'without content doesn''t validate' do
      expect_validating(comment_id: '2a', content: '')
        .to fail_validation('content should not be empty.')
    end

    it 'without content doesn\'t validate' do
      expect_validating(comment_id: '2a', content: '  ')
        .to fail_validation('content should not be empty.')
    end
  end

  describe '#call' do
    it 'calls the corresponding command' do
      comment = double id: '2a'
      user = double
      sub_comment = double
      authority = double
      dead_sub_comment = double
      content = 'hoi'

      ability = double
      ability.stub(:can?).with(:show, comment).and_return(true)
      ability.stub(:can?).with(:create, SubComment).and_return(true)

      Comment.should_receive(:find).with(comment.id).and_return(comment)

      pavlov_options = { current_user: user, ability: ability }
      interactor = described_class.new comment_id: comment.id, content: content,
        pavlov_options: pavlov_options

      Pavlov.should_receive(:command)
            .with(:'sub_comments/create_xxx',
                      parent_id: comment.id, parent_class: 'Comment',
                      content: content, user: user, pavlov_options: pavlov_options)
            .and_return(sub_comment)
      interactor.should_receive(:authority_of_user_who_created).with(sub_comment).
        and_return(authority)
      interactor.should_receive(:create_activity).with(sub_comment)
      KillObject.should_receive(:sub_comment).with(sub_comment, authority: authority).
        and_return(dead_sub_comment)

      result = interactor.execute

      expect(result).to eq dead_sub_comment
    end

    it 'throws an error when the fact relation does not exist' do
      Comment.stub find: nil
      ability = double can?: true

      interactor = described_class.new comment_id: '2a', content: 'content',
        pavlov_options: { current_user: double, ability: ability }
      interactor.stub comment: nil

      expect { interactor.call }
       .to raise_error(Pavlov::ValidationError, "parent does not exist any more")
    end
  end

  describe '.top_fact' do
    it 'returns the top fact for the comment_id' do
      comment_id = '2a'
      fact = double
      comment = double(fact_data: double(fact:fact))
      Comment.should_receive(:find).with(comment_id).and_return(comment)
      ability = double can?: true

      interactor = described_class.new comment_id: comment_id, content: 'hoi',
        pavlov_options: { current_user: double, ability: ability }

      result = interactor.top_fact

      result.should eq fact
    end

    it 'caches the fact' do
      comment_id = '2a'
      fact = double
      comment = double(fact_data: double(fact:fact))
      Comment.should_receive(:find).with(comment_id).and_return(comment)
      ability = double can?: true

      interactor = described_class.new comment_id: comment_id, content: 'hoi',
        pavlov_options: { current_user: double, ability: ability }

      result = interactor.top_fact

      result2 = interactor.top_fact

      result2.should eq fact
    end
  end

  describe '.authority_of_user_who_created' do
    it 'retrieves the authority and kills the subcomment' do
      comment_id = '2a'
      fact = double
      graph_user = double
      authority = double
      user = double
      sub_comment = double(created_by: double(graph_user: graph_user))

      Comment.stub find: nil
      ability = double can?: true

      pavlov_options = { current_user: user, ability: ability }
      interactor = described_class.new comment_id: comment_id, content: 'hoi',
        pavlov_options: pavlov_options

      interactor.should_receive(:top_fact).and_return(fact)
      Pavlov.should_receive(:query)
            .with(:'authority_on_fact_for',
                      fact: fact, graph_user: graph_user,
                      pavlov_options: pavlov_options)
            .and_return(authority)

      result = interactor.authority_of_user_who_created sub_comment

      expect(result).to eq authority
    end
  end
end
