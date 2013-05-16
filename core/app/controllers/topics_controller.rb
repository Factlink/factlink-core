class TopicsController < ApplicationController
  def show
    backbone_responder do
      @topic = topic
    end
  end

  def top_channels
    @channels = get_top_channels
    render 'channels/index'
  end

  def facts
    from = params[:timestamp].to_i if params[:timestamp]
    count = params[:number].to_i if params[:number]
    @facts = interactor :'topics/facts', params[:id], count, from

    respond_to do |format|
      format.json { render }
    end
  end

  def fact
    backbone_responder
  end

  private
    def get_top_channels
      interactor :'channels/top', 12
    end

    def topic
      topic = interactor :"topics/get", params[:id]
      topic || raise_404("Topic not found")
    end
end
