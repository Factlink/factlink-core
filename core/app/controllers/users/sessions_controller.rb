class Users::SessionsController < Devise::SessionsController
  layout "frontend"

  after_filter only: :create { track "Sign out" }
  before_filter :only => [:destroy] { track "Sign in" }
end
