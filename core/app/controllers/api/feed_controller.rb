class Api::FeedController < ApplicationController
  pavlov_action :index, Interactors::Feed::Index
  pavlov_action :count, Interactors::Feed::Count
end
