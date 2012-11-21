# this test isn't in unit-spec because the identitiescontroller actually
# requires the applicationcontroller, making this test kind-of slow
require_relative '../../app/controllers/facts_comments_controller.rb'

describe FactsCommentsController do
  let(:controller) { FactsCommentsController.new }

  describe '.create' do
    it 'calls the interactor with the correct parameters' do
      opinion = 'believes'
      content = 'text of content'
      controller.stub(params: {opnion: opinion, content: content})
      fact_id = 1
      controller.stub(get_fact_id_param: fact_id)

      controller.should_receive(:interactor).with(:create_comment_for_fact, fact_id, opinion, content)

      controller.create
    end
  end

  describe '.destroy' do
    it 'calls the interactor with the correct parameters' do
      opinion = 'believes'
      content = 'text of content'
      controller.stub(params: {opnion: opinion, content: content})
      comment_id = 1
      controller.stub(get_comment_id_param: comment_id)

      controller.should_receive(:interactor).with(:delete_comment_for_fact, comment_id)

      controller.destroy
    end
  end

  describe '.get_fact_id_param' do
    it 'returns fact_id param' do
      fact_id = 1
      controller.stub(params: {fact_id: fact_id.to_s})

      id = controller.send(:get_fact_id_param)

      id.should eq fact_id
    end

    it 'returns id param' do
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
end
