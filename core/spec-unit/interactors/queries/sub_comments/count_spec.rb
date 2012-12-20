require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/sub_comments/count'

describe Queries::SubComments::Count do
  include PavlovSupport

  describe '.validate' do
    let(:subject_class) { Queries::SubComments::Count }

    it 'validates with correct values' do
      expect_validating('1', 'FactRelation').to_not raise_error
    end

    it 'without valid parent_class doesn''t validate' do
      expect_validating(1, 'bla').
        to fail_validation('parent_class should be on of these values: ["Comment", "FactRelation"].')
    end

    it 'without valid parent_id for FactRelation doesn''t validate' do
      expect_validating(2, 'FactRelation').
        to fail_validation('parent_id should be an integer string.')
    end

    it 'without valid parent_id for Comment doesn''t validate' do
      expect_validating(1, 'Comment').
        to fail_validation('parent_id should be an hexadecimal string.')
    end
  end

  describe '.execute' do
    it 'calls the index query and counts the results' do
      parent_id = 1
      parent_class = 'FactRelation'
      sub_comments = [mock, mock, mock]

      query = Queries::SubComments::Count.new parent_id.to_s, parent_class
      query.should_receive(:query).with(:'sub_comments/index', parent_id, parent_class).
        and_return(sub_comments)

      expect(query.execute).to eq sub_comments.length
    end
  end

  describe '.normalized_parent_id' do
    it 'converts to an integer if the class is FactRelation' do
      parent_id = '1'
      parent_class = 'FactRelation'

      query = Queries::SubComments::Count.new parent_id, parent_class
      expect(query.normalized_parent_id).to eq parent_id.to_i
    end

    it 'returns a string if the class is Comment' do
      parent_id = '2a'
      parent_class = 'Comment'

      query = Queries::SubComments::Count.new parent_id, parent_class
      expect(query.normalized_parent_id).to eq parent_id
    end
  end

end
