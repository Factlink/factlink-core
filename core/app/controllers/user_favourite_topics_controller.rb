class UserFavouriteTopicsController < ApplicationController

  def index
    @topics = old_interactor :'topics/favourites', username

    render 'topics/index', format: 'json'
  end

  def update
    old_interactor :'topics/favourite', username, slug_title
    return_ok
  end

  def destroy
    old_interactor :'topics/unfavourite', username, slug_title
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
    params[:slug_title] || params[:id]
  end
end
