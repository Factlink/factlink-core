module ControllerMethods
  def authenticate_user!(user)
    request.env['warden'] = mock(Warden, :authenticate => user, :authenticate! => user)
    request.env['test_logged_in'] = true
  end

  def ability
    unless @ability
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      @ability.stub feature_toggles: []
      @ability.stub signed_in?: request.env['test_logged_in'] || false
      subject.stub current_ability: @ability
    end
    @ability
  end

  def should_check_can(*args)
    ability.should_receive(:authorize!).with(*args)
  end

  def should_check_admin_ability
    ability.should_receive(:authorize!).once.with(:access, Ability::AdminArea)
  end

end
