module BrowserHelper
  # Makes use of the browser gem:
  # https://github.com/fnando/browser

  def browser_supported?
    return true if browser_preferred?

    browser.safari?
  end

  def browser_preferred?
    browser.chrome? or browser.firefox?
  end

  def preferred_browser_name
    if browser.chrome?
      'chrome'
    elsif browser.firefox?
      'firefox'
    else
      'unsupported-browser'
    end
  end

end
