class TopicsController < ApplicationController
  def show
    backbone_responder do
      @topic = topic
    end
  end

  def facts
    from = params[:timestamp].to_i if params[:timestamp]
    count = params[:number].to_i if params[:number]
    @facts = interactor(:'topics/facts', slug_title: params[:id], count: count, max_timestamp: from)

    respond_to do |format|
      format.json { render }
    end
  end

  def fact
    backbone_responder
  end

  private

  def topic
    topic = interactor(:'topics/get', slug_title: params[:id])
    topic || raise_404("Topic not found")
  end
end
