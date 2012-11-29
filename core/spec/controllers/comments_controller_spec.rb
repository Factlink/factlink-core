# this test isn't in unit-spec because the identitiescontroller actually
# requires the applicationcontroller, making this test kind-of slow
require_relative '../../app/controllers/comments_controller.rb'

describe CommentsController do
  let(:controller) { CommentsController.new }

  describe '.create' do
    it 'calls the interactor with the correct parameters' do
      opinion = 'believes'
      content = 'text of content'
      controller.stub(params: {opinion: opinion, content: content})
      fact_id = 1
      controller.stub(get_fact_id_param: fact_id)
      comment = stub(opinion: opinion, content: content)

      controller.should_receive(:interactor).with(:create_comment_for_fact, fact_id, opinion, content).and_return(comment)
      controller.should_receive(:render).with('comments/create')

      controller.create

      controller.instance_variable_get(:@comment).should eq comment
    end
  end

  describe '.destroy' do
    it 'calls the interactor with the correct parameters' do
      opinion = 'believes'
      content = 'text of content'
      controller.stub(params: {opinion: opinion, content: content})
      comment_id = 1
      controller.stub(get_comment_id_param: comment_id)

      controller.should_receive(:interactor).with(:delete_comment, comment_id)
      controller.should_receive(:render).with(json: {}, status: :ok)

      controller.destroy
    end
  end

  describe '.index' do
    it 'calls the interactor with the correct parameters' do
      fact_id = 1
      opinion = 'believes'
      controller.stub(get_fact_id_param: fact_id)
      controller.stub(params: {opinion: opinion})
      comment1 = mock
      comment2 = mock

      controller.should_receive(:interactor).with(:get_comments_for_fact, fact_id, opinion).and_return([comment1, comment2])
      controller.should_receive(:render).with('comments/index')

      controller.index

      controller.instance_variable_get(:@comments).should eq [comment1, comment2]
    end
  end

  describe '.update' do
  end

  describe '.get_fact_id_param' do
    it 'returns fact_id param' do
      fact_id = 1
      controller.stub(params: {id: fact_id.to_s})

      id = controller.send(:get_fact_id_param)

      id.should eq fact_id
    end

    it 'errors when no id param present' do
      controller.stub(params: {} )

      expect { controller.send(:get_fact_id_param) }.
        to raise_error ('No Fact id is supplied.')
    end
  end

  describe '.get_comment_id_param' do
    it 'returns comment_id param' do
      comment_id = '1'
      controller.stub(params: {id: comment_id.to_s})

      id = controller.send(:get_comment_id_param)

      id.should eq comment_id
    end
  end
end
