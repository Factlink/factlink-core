class Api::GroupsController < ApplicationController
  pavlov_action :create, Interactors::Groups::Create
end
