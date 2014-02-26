class Api::UsersController < ApplicationController
  pavlov_action :feed, Interactors::Feed::Index
end
