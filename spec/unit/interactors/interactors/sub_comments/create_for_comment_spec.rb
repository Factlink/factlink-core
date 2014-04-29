require 'pavlov_helper'
require_relative '../../../../../app/interactors/interactors/sub_comments/create'
require_relative '../../../../../app/interactors/backend/sub_comments.rb'

describe Interactors::SubComments::Create do
  include PavlovSupport

  before do
    stub_classes 'Comment', 'SubComment'
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
      dead_sub_comment = double
      content = 'hoi'

      ability = double
      ability.stub(:can?).with(:show, comment).and_return(true)
      ability.stub(:can?).with(:create, SubComment).and_return(true)

      Comment.should_receive(:find).with(comment.id).and_return(comment)

      pavlov_options = { current_user: user, ability: ability, time: double }
      interactor = described_class.new comment_id: comment.id, content: content,
                                       pavlov_options: pavlov_options

      Backend::SubComments
        .should_receive(:create!)
        .with(parent_id: comment.id, content: content, user: user, created_at: pavlov_options[:time])
        .and_return(sub_comment)
      interactor.should_receive(:create_activity).with(sub_comment)
      Backend::SubComments.should_receive(:dead_for).with(sub_comment).
        and_return(dead_sub_comment)

      result = interactor.execute

      expect(result).to eq dead_sub_comment
    end

    it 'throws an error when the comment does not exist' do
      Comment.stub find: nil
      ability = double can?: true

      interactor = described_class.new comment_id: '2a', content: 'content',
                                       pavlov_options: { current_user: double, ability: ability }
      interactor.stub comment: nil

      expect { interactor.call }
       .to raise_error(Pavlov::ValidationError, "parent does not exist any more")
    end
  end
end
