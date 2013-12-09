class MixpanelRequestPresenter

  def initialize(request)
    @request = request
  end

  def to_hash
    # Filter out required parameters for Mixpanel, in stead of sending the full
    # request.env. Sending the full request.env will break the Mixpanel object.

    clean_env = {}

    if @request.env.has_key?(:HTTP_X_FORWARDED_FOR)
      clean_env[:HTTP_X_FORWARDED_FOR] = @request.env[:HTTP_X_FORWARDED_FOR]
    end
    if @request.env.has_key?(:REMOTE_ADDR)
      clean_env[:REMOTE_ADDR] = @request.env[:REMOTE_ADDR]
    end
    if @request.env.has_key?(:mixpanel_events)
      clean_env[:mixpanel_events] = @request.env[:mixpanel_events]
    end

    return clean_env
  end

end
