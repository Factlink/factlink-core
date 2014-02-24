class Api::FeedController < ApplicationController
  pavlov_action :index, Interactors::Feed::Index
end
