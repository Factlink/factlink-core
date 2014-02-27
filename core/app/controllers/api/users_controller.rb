class Api::UsersController < ApplicationController
  pavlov_action :feed, Interactors::Users::Feed
end
