module BrowserHelper
  # Makes use of the browser gem:
  # https://github.com/fnando/browser

  def browser_unsupported?
    browser.ie?
  end

  def browser_preferred?
    browser.chrome? or browser.firefox? or browser.safari? or browser.phantom_js?
  end

  def browser_class_name
    if browser.chrome?
      'chrome'
    elsif browser.firefox?
      'firefox'
    elsif browser.safari?
      'safari'
    elsif browser.phantom_js?
      'phantom_js unsupported-browser'
    else
      'unsupported-browser'
    end
  end

  # this method defines whether we should show a notification
  # that someone is using a non-preferred (not supporting plugin)
  # browser
  def show_nonpreferred_browser_warning
    if controller_name == "tour"
      false # no warnings in the tour
    elsif !current_user
      false # no warnings for people without accounts
    elsif browser_unsupported?
      false # already gets a big (modal) warning
    elsif browser_preferred?
      false # this browser is preferred, so no need for a warning
    else
      true
    end
  end
end
