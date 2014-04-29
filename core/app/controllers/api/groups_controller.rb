class Api::GroupsController < ApplicationController
  pavlov_action :create, Interactors::Groups::Create
  pavlov_action :index, Interactors::Groups::List
end
