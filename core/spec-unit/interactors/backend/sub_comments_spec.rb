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
    let(:parent_id) { '2a' }

    let(:sub_comments) do
      [
        double(
          id: '2a',
          created_by: double,
          created_by_id: double,
          created_at: mock,
          content: 'bar',
          parent_id: parent_id,
        ),
        double(
          id: '2b',
          created_by: double,
          created_by_id: double,
          created_at: mock,
          content: 'foo',
          parent_id: parent_id,
        )
      ]
    end

    let(:dead_sub_comments) do
      sub_comments.map { |c| Backend::SubComments.dead_for(c) }
    end

    it 'no subcomments' do
      sub_comment_finder = double

      SubComment.stub(:any_in)
        .with(parent_id: [parent_id])
        .and_return(sub_comment_finder)
      sub_comment_finder.stub(:asc)
        .with(:created_at).and_return([])

      result = Backend::SubComments.index(parent_ids_in: parent_id)

      expect(result).to eq []
    end

    it 'two subcomments' do
      parent_id = '2a'
      sub_comment_finder = double

      SubComment.stub(:any_in)
        .with(parent_id: [parent_id])
        .and_return(sub_comment_finder)
      sub_comment_finder.stub(:asc)
        .with(:created_at).and_return(sub_comments)

      result = Backend::SubComments.index(parent_ids_in: parent_id)

      expect(result).to eq dead_sub_comments
    end

    it 'retrieves subcomments for multiple comments' do
      parent_ids = ['2a', '2b']

      sub_comment_finder = double

      SubComment.stub(:any_in)
        .with(parent_id: parent_ids)
        .and_return(sub_comment_finder)
      sub_comment_finder.stub(:asc)
        .with(:created_at).and_return(sub_comments)

      result = Backend::SubComments.index(parent_ids_in: parent_ids)

      expect(result).to eq dead_sub_comments
    end
  end

  describe '#destroy!' do
    it "should remove the comment" do
      sub_comment = double id: '1a'
      SubComment.should_receive(:find).with(sub_comment.id)
                .and_return(sub_comment)

      sub_comment.should_receive(:delete)

      Backend::SubComments.destroy!(id: sub_comment.id)
    end
  end

  describe '#create!' do
    it "should create a sub_comment" do
      parent_id = 1
      content = 'message'
      user = double

      comment = double(:comment, id: 10)

      comment.should_receive(:parent_id=).with(parent_id.to_s)
      SubComment.should_receive(:new).and_return(comment)
      comment.should_receive(:created_by=).with(user)
      comment.should_receive(:content=).with(content)
      comment.should_receive(:save!)

      result = Backend::SubComments.create!(parent_id: parent_id, content: content, user: user)

      expect(result).to eq comment
    end
  end
end
