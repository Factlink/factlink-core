class Api::FeedController < ApplicationController
  pavlov_action :global, Interactors::Feed::Global
  pavlov_action :discussions, Interactors::Feed::GlobalDiscussions
  pavlov_action :personal, Interactors::Feed::Personal
end
