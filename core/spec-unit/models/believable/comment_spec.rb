require_relative '../../../app/models/believable.rb'
require_relative '../../../app/models/believable/commentje.rb'
require 'pavlov_helper'

describe Believable::Comment do
  include PavlovSupport

  before do
    stub_classes 'Nest'
  end

  describe "its constructor" do
    it "should create a subclass of believable" do
      comment_id = mock
      Nest.stub new: mock
      believable_comment = Believable::Comment.new comment_id
      expect(believable_comment).to be_kind_of(Believable)
    end
    it "should set key 'Comment:<id>'" do
      nest = mock
      comment_id = 'mock_ohm_id'

      Nest.should_receive(:new)
          .with("Comment:#{comment_id}:believable")
          .and_return(nest)

      believable_comment = Believable::Comment.new comment_id

      expect(believable_comment.key).to eq nest
    end
  end
end
