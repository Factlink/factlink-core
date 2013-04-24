class UserFavouriteTopicsController < ApplicationController

  def index
    @topics = interactor :'topics/favourites', username

    render 'topics/index', format: 'json'
  end

  def create
    interactor :'topics/favourite', username, slug_title
    track 'Topic: Favourited'
    return_ok
  end

  def destroy
    interactor :'topics/unfavourite', username, slug_title
    track 'Topic: Unfavourited'
    return_ok
  end

  private
  def return_ok
    respond_to do |format|
      format.json { head :ok }
    end
  end

  def username
    params[:username]
  end

  def slug_title
    params[:id]
  end
  
end
