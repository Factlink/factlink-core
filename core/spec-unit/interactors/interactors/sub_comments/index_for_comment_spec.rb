require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/sub_comments/index_for_comment'

describe Interactors::SubComments::IndexForComment do
  include PavlovSupport
  before do
    stub_classes 'SubComment', 'Comment', 'KillObject',
                 'Queries::SubComments::Index'
  end

  describe '#authorized?' do
    it 'checks if the comment can be shown' do
      comment_id = '1a'
      comment = double
      ability = double
      ability.should_receive(:can?).with(:show, comment).and_return(false)
      interactor = described_class.new(comment_id: comment_id, pavlov_options: { ability: ability })

      Comment.stub(:find).with(comment_id).and_return(comment)

      expect do
        interactor.call
      end.to raise_error(Pavlov::AccessDenied)
    end
  end

  describe 'validations' do
    it 'without comment_id doesn''t validate' do
      expect_validating(comment_id: nil)
        .to fail_validation('comment_id should be an hexadecimal string.')
    end
  end

  describe '#call' do
    it do
      comment_id = '2b'
      sub_comments = [double, double]
      dead_sub_comments = [double, double]
      authorities = [10, 20]
      options = {ability: double(can?: true)}
      interactor = described_class.new(comment_id: comment_id,
        pavlov_options: options)

      Comment.stub(:find).with(comment_id)
             .and_return(double)
      Pavlov.should_receive(:query)
            .with(:'sub_comments/index',
                      parent_ids_in: comment_id, parent_class: 'Comment',
                      pavlov_options: options)
            .and_return(sub_comments)
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

      expect( interactor.call ).to eq dead_sub_comments
    end

    it 'throws an error when the comment does not exist' do
      stub_const 'Pavlov::ValidationError', RuntimeError

      options = {ability: double(can?: true)}

      Comment.stub(:find).with('2b')
             .and_return(nil)

      interactor = described_class.new(comment_id: '2b', pavlov_options: options)

      expect do
        interactor.call
      end.to raise_error(Pavlov::ValidationError, 'comment does not exist any more')
    end
  end

  describe '#top_fact' do
    before do
      described_class.any_instance.stub(:authorized?).and_return(true)
    end

    it 'returns the top fact for the comment_id' do
      comment_id = '2a'
      fact = double
      comment = double(fact_data: double(fact:fact))
      interactor = described_class.new(comment_id: comment_id)

      Comment.should_receive(:find).with(comment_id).and_return(comment)

      result = interactor.top_fact

      result.should eq fact
    end

    it 'caches the fact' do
      comment_id = '2a'
      fact = double
      comment = double(fact_data: double(fact:fact))
      interactor = described_class.new(comment_id: comment_id)

      Comment.should_receive(:find).with(comment_id).and_return(comment)

      interactor.top_fact
      next_result = interactor.top_fact

      expect( next_result ).to eq fact
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
      sub_comment = double(created_by: double(graph_user: graph_user))
      interactor = described_class.new(comment_id: comment_id)

      interactor.should_receive(:top_fact).and_return(fact)
      Pavlov.should_receive(:query)
            .with(:'authority_on_fact_for',
                      fact: fact, graph_user: graph_user)
            .and_return authority

      result = interactor.authority_of_user_who_created sub_comment

      expect(result).to eq authority
    end
  end
end
