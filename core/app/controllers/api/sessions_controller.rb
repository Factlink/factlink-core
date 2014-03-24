class Api::SessionsController < ApplicationController
  pavlov_action :current, Interactors::GetSession
end
