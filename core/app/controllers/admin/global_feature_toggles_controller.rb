class Admin::GlobalFeatureTogglesController < AdminController

  layout "admin"

  def show
    @global_features = interactor :'global_features/all'
  end

  def update
    @global_features = params[:features].andand.keys
    interactor :'global_features/set', @global_features
    render :show
  end

end
