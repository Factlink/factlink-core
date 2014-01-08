class TopicsController < ApplicationController
  def show
    backbone_responder do
      @topic = interactor(:'topics/get', slug_title: params[:id]) or raise_404("Topic not found")
    end
  end

  def facts
    render json: []
  end
end
