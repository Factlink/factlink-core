class Admin::GlobalFeatureTogglesController < AdminController
  #TODO: this must not accept JSON since that bypasses csrf protection

  layout "admin"

  def show
    @enabled_features = interactor :'global_features/all'
  end

  def update
    @enabled_features = (params[:features] || {}).keys
    interactor(:'global_features/set', features: @enabled_features)
    render :show
  end

  helper_method :dead_features
  def dead_features
    @enabled_features.select {|f| !Ability::FEATURES.include? f }
  end
end
