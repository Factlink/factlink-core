module ControllerMethods
  def authenticate_user!(user)
    request.env['warden'] = mock(Warden, :authenticate => user, :authenticate! => user)
    request.env['test_logged_in'] = true
  end

  def ability
    unless @ability
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      @ability.should_receive(:feature_toggles).any_number_of_times.and_return([])
      @ability.should_receive(:signed_in?).any_number_of_times.and_return(request.env['test_logged_in'] || false)
      subject.should_receive(:current_ability).any_number_of_times.and_return(@ability)
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
