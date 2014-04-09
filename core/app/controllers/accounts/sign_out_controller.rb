class Accounts::SignOutController < Accounts::BaseController
  around_filter :render_trigger_event_on_social_account_error

  def destroy
    sign_out
    render_trigger_event 'account_success', interactor(:'users/get_non_signed_in')
  end
end
