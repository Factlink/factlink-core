require 'pavlov_helper'
require_relative '../../../app/interactors/backend/sub_comments'

describe Backend::SubComments do
  include PavlovSupport
  before do
    stub_classes 'SubComment', 'KillObject'
  end

  describe '#count' do
    it 'counts the number of subcomments in mongo' do
      parent_id = 1

      expect(SubComment)
        .to receive(:where)
        .with(parent_id: parent_id.to_s)
        .and_return(double(count: 4))

      result = Backend::SubComments.count(parent_id: parent_id)

      expect(result).to eq 4
    end
  end

  describe '#index' do
    it 'no subcomments' do
      parent_id = 1
      sub_comment_finder1, sub_comment_finder2 = double, double

      SubComment.stub(:any_in)
        .with(parent_id: [parent_id])
        .and_return(sub_comment_finder2)
      sub_comment_finder2.stub(:asc)
        .with(:created_at).and_return([])

      result = Backend::SubComments.index(parent_ids_in: parent_id)

      expect(result).to eq []
    end

    it 'two subcomments' do
      parent_id = '2a'
      sub_comments = [double, double]
      dead_sub_comments = [double, double]
      sub_comment_finder1, sub_comment_finder2 = double, double

      SubComment.stub(:any_in)
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

      result = Backend::SubComments.index(parent_ids_in: parent_id)

      expect(result).to eq dead_sub_comments
    end

    it 'retrieves subcomments for multiple comments' do
      parent_ids = ['2a', '2b']
      sub_comments = [double, double]
      dead_sub_comments = [double, double]
      sub_comment_finder1, sub_comment_finder2 = double, double

      SubComment.stub(:any_in)
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

      result = Backend::SubComments.index(parent_ids_in: parent_ids)

      expect(result).to eq dead_sub_comments
    end
  end

  describe '#destroy' do
    it "should remove the comment" do
      sub_comment = double id: '1a'
      SubComment.should_receive(:find).with(sub_comment.id)
                .and_return(sub_comment)

      sub_comment.should_receive(:delete)

      Backend::SubComments.destroy!(id: sub_comment.id)
    end

  end
end
