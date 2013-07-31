class Admin::GlobalFeatureTogglesController < AdminController

  layout "admin"

  def show
    @enabled_features = interactor :'global_features/all'
  end

  def update
    @enabled_features = params[:features].andand.keys || []
    interactor :'global_features/set', @enabled_features
    render :show
  end

end
