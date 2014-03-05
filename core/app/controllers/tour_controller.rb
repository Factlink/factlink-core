class TourController < ApplicationController
  def install_extension # TODO: remove
    render layout: "tour"
  end

  def interests # TODO: remove
    render text: "", layout: "tour"
  end
end
