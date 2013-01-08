require_relative '../../../app/models/believable.rb'
require_relative '../../../app/models/believable/commentje.rb'
require 'pavlov_helper'

describe Believable::Commentje do
  include PavlovSupport

  before do
    stub_classes 'Ohm::Key'
  end

  describe "its constructor" do
    it "should create a subclass of believable" do
      comment_id = mock
      Ohm::Key.stub new: mock
      believable_comment = Believable::Commentje.new comment_id
      expect(believable_comment).to be_kind_of(Believable)
    end
    it "should set key 'Comment:<id>'" do
      nest = mock
      comment_id = 'mock_ohm_id'

      Ohm::Key.should_receive(:new)
          .with("Comment:#{comment_id}:believable")
          .and_return(nest)

      believable_comment = Believable::Commentje.new comment_id

      expect(believable_comment.key).to eq nest
    end
  end
end
