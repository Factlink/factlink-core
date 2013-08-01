# this test isn't in unit-spec because the TopicsController actually
# requires the ApplicationController, making this test kind-of slow

require_relative '../../app/controllers/application_controller.rb'
require_relative '../../app/controllers/topics_controller.rb'

describe TopicsController do
  let(:controller) { TopicsController.new }

  describe '.show' do
    context 'json' do
      it 'calls the interactor with the correct parameters' do
        slug_title = 'foo'
        topic = stub
        format = mock(json: nil, html: nil)

        controller.stub(params: {id: slug_title})

        controller.should_receive(:old_interactor).with(:"topics/get", slug_title).and_return(topic)
        controller.should_receive(:respond_to).and_yield format
        format.should_receive(:json).and_yield

        controller.show
        controller.instance_variable_get(:@topic).should eq topic
      end
    end

    context 'html' do
      it 'should render a backbone page' do
        format = mock(json: nil, html: nil)

        controller.should_receive(:backbone_responder)

        controller.show
      end
    end
  end
end
