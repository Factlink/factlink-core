require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/sub_comments/index'

describe Queries::SubComments::Index do
  include PavlovSupport

  describe 'validates' do
    it 'without valid parent_class doesn''t validate' do
      expect_validating(parent_ids_in: 1, parent_class: 'bla')
        .to fail_validation('parent_class should be on of these values: ["Comment", "FactRelation"].')
    end

    it 'without valid parent_id for FactRelation doesn''t validate' do
      expect_validating(parent_ids_in: '2a', parent_class: 'FactRelation')
        .to fail_validation('parent_id[0] should be an integer string.')
    end

    it 'without valid parent_id for Comment doesn''t validate' do
      expect_validating(parent_ids_in: 1, parent_class: 'Comment')
        .to fail_validation('parent_id[0] should be an hexadecimal string.')
    end

    it 'with an invalid parent_id for Comment doesn''t validate' do
      expect_validating(parent_ids_in: ['1a', 'henk', '3c'], parent_class: 'Comment')
        .to fail_validation('parent_id[1] should be an hexadecimal string.')
    end
  end

  describe '#call' do
    before do
      stub_classes('SubComment', 'KillObject')
    end

    it 'no subcomments' do
      parent_id = 1
      parent_class = 'FactRelation'
      sub_comment_finder1, sub_comment_finder2 = mock, mock
      query = described_class.new parent_ids_in: parent_id,
        parent_class: parent_class

      SubComment.stub(:where)
        .with(parent_class: parent_class)
        .and_return(sub_comment_finder1)
      sub_comment_finder1.stub(:any_in)
        .with(parent_id: [parent_id.to_s])
        .and_return(sub_comment_finder2)
      sub_comment_finder2.stub(:asc)
        .with(:created_at).and_return([])

      expect(query.call).to eq []
    end

    it 'two subcomments' do
      parent_id = '2a'
      parent_class = 'Comment'
      sub_comments = [mock, mock]
      dead_sub_comments = [mock, mock]
      sub_comment_finder1, sub_comment_finder2 = mock, mock
      query = described_class.new parent_ids_in: parent_id,
        parent_class: parent_class

      SubComment.stub(:where)
        .with(parent_class: parent_class)
        .and_return(sub_comment_finder1)
      sub_comment_finder1.stub(:any_in)
        .with(parent_id: [parent_id])
        .and_return(sub_comment_finder2)
      sub_comment_finder2.stub(:asc)
        .with(:created_at).and_return(sub_comments)
      KillObject.stub(:sub_comment)
        .with(sub_comments[0])
        .and_return(dead_sub_comments[0])
      KillObject.stub(:sub_comment)
        .with(sub_comments[1])
        .and_return(dead_sub_comments[1])

      expect(query.call).to eq dead_sub_comments
    end

    it 'retrieves subcomments for multiple comments' do
      parent_ids = ['2a', '2b']
      parent_class = 'Comment'
      sub_comments = [mock, mock]
      dead_sub_comments = [mock, mock]
      sub_comment_finder1, sub_comment_finder2 = mock, mock
      query = described_class.new parent_ids_in: parent_ids,
        parent_class: parent_class

      SubComment.stub(:where)
        .with(parent_class: parent_class)
        .and_return(sub_comment_finder1)
      sub_comment_finder1.stub(:any_in)
        .with(parent_id: parent_ids)
        .and_return(sub_comment_finder2)
      sub_comment_finder2.stub(:asc)
        .with(:created_at).and_return(sub_comments)
      KillObject.stub(:sub_comment)
        .with(sub_comments[0])
        .and_return(dead_sub_comments[0])
      KillObject.stub(:sub_comment)
        .with(sub_comments[1])
        .and_return(dead_sub_comments[1])

      expect(query.call).to eq dead_sub_comments
    end
  end
end
