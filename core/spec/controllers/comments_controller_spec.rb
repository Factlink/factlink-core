# this test isn't in unit-spec because the CommentsController actually
# requires the ApplicationController, making this test kind-of slow

require_relative '../../app/controllers/comments_controller.rb'

describe CommentsController do
  let(:controller) { CommentsController.new }

  describe '.create' do
    it 'calls the interactor with the correct parameters' do
      type = 'believes'
      content = 'text of content'
      controller.stub(params: {type: type, content: content})
      fact_id = 1
      controller.stub(get_fact_id_param: fact_id)
      comment = double(type: type, content: content)

      controller.should_receive(:old_interactor).with(:"comments/create", fact_id, type, content).and_return(comment)
      controller.should_receive(:render).with('comments/show', {formats: [:json]})

      controller.create

      controller.instance_variable_get(:@comment).should eq comment
    end
  end

  describe '.destroy' do
    it 'calls the interactor with the correct parameters' do
      type = 'believes'
      content = 'text of content'
      controller.stub(params: {type: type, content: content})
      comment_id = 1
      controller.stub(get_comment_id_param: comment_id)

      controller.should_receive(:old_interactor).with(:"comments/delete", comment_id)
      controller.should_receive(:render).with(json: {}, status: :ok)

      controller.destroy
    end
  end

  describe '.update' do
    it 'calls the interactor with the correct parameters' do
      comment_id = '123abc'
      opinion = 'believes'
      controller.stub(get_comment_id_param: comment_id)
      controller.stub(params: {opinion: opinion})

      controller.should_receive(:old_interactor).with('comments/update_opinion', comment_id, opinion)
      controller.should_receive(:render).with('comments/show', {formats: [:json]})

      controller.update
    end
  end

  describe '.sub_comments_index' do
    it 'calls the interactor with the correct parameters' do
      comment_id = '123abc'
      sub_comments = double
      controller.stub(get_comment_id_param: comment_id)

      controller.should_receive(:old_interactor).with(:'sub_comments/index_for_comment', comment_id).
        and_return(sub_comments)
      controller.should_receive(:render).with('sub_comments/index', {formats: [:json]})

      controller.sub_comments_index

      controller.instance_variable_get(:@sub_comments).should eq sub_comments
    end
  end

  describe '.sub_comments_create' do
    it 'calls the interactor with the correct parameters' do
      comment_id = '123abc'
      content = 'hoi'
      sub_comment = double
      controller.stub(get_comment_id_param: comment_id)
      controller.stub(params: {content: content})

      controller.should_receive(:old_interactor).with(:'sub_comments/create_for_comment', comment_id, content).
        and_return(sub_comment)
      controller.should_receive(:render).with('sub_comments/show', {formats: [:json]})

      controller.sub_comments_create

      controller.instance_variable_get(:@sub_comment).should eq sub_comment
    end
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
