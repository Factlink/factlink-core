module ControllerMethods
  def authenticate_user!(user)
    request.env['warden'] = mock(Warden, :authenticate => user, :authenticate! => user)
  end
  
  def get_ability
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    subject.should_receive(:current_ability).any_number_of_times.and_return(@ability)
  end
  
  def should_check_can(*args)
    @ability.should_receive(:authorize!).with(*args)
  end
  
end