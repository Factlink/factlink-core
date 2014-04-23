class Api::AnnotationsController < ApplicationController
  pavlov_action :show, Interactors::Facts::Get
  pavlov_action :create, Interactors::Facts::Create
  pavlov_action :search, Interactors::Facts::Search
end
