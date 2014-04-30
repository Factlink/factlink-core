class Api::GroupsController < ApplicationController
  pavlov_action :create, Interactors::Groups::Create
  pavlov_action :index, Interactors::Groups::List
  pavlov_action :feed, Interactors::Groups::Feed
end
