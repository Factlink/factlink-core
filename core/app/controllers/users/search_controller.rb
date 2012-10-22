class Users::SearchController < ApplicationController
  def search
    puts params.inspect
    interactor = SearchUserInteractor.new params[:s].to_s, current_user, ability: current_ability
    @users = interactor.execute
    render 'users/search'
  end
end