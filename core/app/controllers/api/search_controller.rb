class Api::SearchController < ApplicationController
  pavlov_action :all, Interactors::Search::All
end
