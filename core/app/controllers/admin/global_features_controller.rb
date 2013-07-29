class Admin::GlobalFeaturesController < AdminController

  layout "admin"

  def index
    @global_features = interactor :'global_features/all'
  end

  def update
    render 'index'
  end

end
