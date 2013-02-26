module AuthenticationHelper
  def return_to_fields_for_sign_in
    # Check whether this is secure:
    hidden_field_tag(:return_to, params[:return_to]) +
      hidden_field_tag(:return_to_on_fail, return_to_on_fail)
  end

  def return_to_on_fail
    original_url = request.original_url

    if original_url =~ /show_sign_in/ or
           original_url =~ /\/users\/sign_in/
      original_url
    elsif original_url !~ /\?/
      original_url + '?show_sign_in=1'
    else
      original_url + '&show_sign_in=1'
    end
  end

end
