require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/sub_comments/index'

describe Queries::SubComments::Index do
  include PavlovSupport

  describe 'initialize' do
    it 'correctly' do
      expect { Queries::SubComments::Index.new 1, 'FactRelation' }.should_not be_nil
    end
  end

  describe '.validate' do
    let(:subject_class) { Queries::SubComments::Index }

    it 'without valid parent_class doesn''t validate' do
      expect_validating(1, 'bla').
        to fail_validation('parent_class should be on of these values: ["Comment", "FactRelation"].')
    end

    it 'without valid parent_id for FactRelation doesn''t validate' do
      expect_validating('2a', 'FactRelation').
        to fail_validation('parent_id should be an integer.')
    end

    it 'without valid parent_id for Comment doesn''t validate' do
      expect_validating(1, 'Comment').
        to fail_validation('parent_id should be an hexadecimal string.')
    end
  end

  describe '.execute' do
    before do
      stub_classes('SubComment','KillObject')
    end

    it 'no subcomments' do
      parent_id = 1
      parent_class = 'FactRelation'
      SubComment.should_receive(:find).with(parent_id: parent_id.to_s,
        parent_class: parent_class).and_return(SubComment)
      SubComment.should_receive(:asc).with(:created_at).
        and_return([])

      results = (Queries::SubComments::Index.new parent_id, parent_class).execute

      results.should eq []
    end

    it 'two subcomments' do
      parent_id = '2a'
      parent_class = 'Comment'
      sub_comment1 = mock()
      sub_comment2 = mock()
      dead_sub_comment1 = mock()
      dead_sub_comment2 = mock()
      SubComment.should_receive(:find).with(parent_id: parent_id, parent_class: parent_class).and_return(SubComment)
      SubComment.should_receive(:asc).with(:created_at).and_return([sub_comment1, sub_comment2])
      KillObject.should_receive(:sub_comment).with(sub_comment1).and_return(dead_sub_comment1)
      KillObject.should_receive(:sub_comment).with(sub_comment2).and_return(dead_sub_comment2)

      results = (Queries::SubComments::Index.new parent_id, parent_class).execute

      results.should eq [dead_sub_comment1, dead_sub_comment2]
    end
  end
end
