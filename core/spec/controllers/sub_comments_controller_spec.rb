require 'spec_helper'
require 'pavlov_helper'

describe SubCommentsController do
  include PavlovSupport

  describe '.index' do
    it 'calls the interactor with the correct parameters' do
      fact_relation_id = 123
      sub_comments = mock
      controller.stub(params: {id: fact_relation_id.to_s})

      controller.should_receive(:interactor).with(:'sub_comments/index_for_fact_relation', fact_relation_id).
        and_return(sub_comments)
      controller.should_receive(:render).with('sub_comments/index')

      controller.index

      controller.instance_variable_get(:@sub_comments).should eq sub_comments
    end
  end

  describe '.create' do
    it 'calls the interactor with the correct parameters' do
      fact_relation_id = 123
      content = 'hoi'
      sub_comment = mock
      controller.stub(params: {content: content, id: fact_relation_id.to_s})

      controller.should_receive(:interactor).with(:'sub_comments/create_for_fact_relation', fact_relation_id, content).
        and_return(sub_comment)
      controller.should_receive(:render).with('sub_comments/show')

      controller.create

      controller.instance_variable_get(:@sub_comment).should eq sub_comment
    end
  end
end
