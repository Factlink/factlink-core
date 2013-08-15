class UserFavouriteTopicsController < ApplicationController

  def index
    @topics = interactor(:'topics/favourites', user_name: username)

    render 'topics/index', format: 'json'
  end

  def update
    interactor(:'topics/favourite', user_name: username, slug_title: slug_title)
    return_ok
  end

  def destroy
    interactor(:'topics/unfavourite', user_name: username, slug_title: slug_title)
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
