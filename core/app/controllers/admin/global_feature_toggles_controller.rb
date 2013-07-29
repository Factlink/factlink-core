class Admin::GlobalFeatureTogglesController < AdminController

  layout "admin"

  def show
    @global_features = interactor :'global_features/all'
  end

  def update
    render :show
  end

end
