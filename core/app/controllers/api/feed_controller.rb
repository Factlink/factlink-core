class Api::FeedController < ApplicationController
  pavlov_action :global, Interactors::Feed::Global
  pavlov_action :personal, Interactors::Feed::Personal
end
