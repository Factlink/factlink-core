module ControllerMethods
  def authenticate_user!(user)
    request.env['warden'] = mock(Warden, :authenticate => user, :authenticate! => user)
  end
  
  # we call this explicitly in the before, so the default ability is empty
  # that means we need to explicitly test that each ability is tested
  def get_ability
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    subject.should_receive(:current_ability).any_number_of_times.and_return(@ability)
  end
  
  def should_check_can(*args)
    @ability.should_receive(:authorize!).with(*args)
  end
  
end