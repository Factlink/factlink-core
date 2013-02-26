module AuthenticationHelper
  def return_to_fields_for_sign_in
    # Check whether this is secure:
    hidden_field_tag(:return_to, params[:return_to])
  end
end
