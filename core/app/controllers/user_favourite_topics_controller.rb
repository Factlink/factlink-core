class UserFavouriteTopicsController < ApplicationController

  def index
    @topics = interactor(:'topics/favourites', user_name: username)

    render 'topics/index', format: 'json'
  end

  def update
    interactor(:'topics/favourite', user_name: username, slug_title: slug_title)
    render json: {}
  end

  def destroy
    interactor(:'topics/unfavourite', user_name: username, slug_title: slug_title)
    render json: {}
  end

  private

  def username
    params[:username]
  end

  def slug_title
    params[:slug_title] || params[:id]
  end
end
